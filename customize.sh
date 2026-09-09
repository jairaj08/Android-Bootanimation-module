##########################################################################################
# Bootanimation module installer
#
# The payload is copied into the module overlay rather than directly into /system. This
# is important on system-as-root, dynamic-partition, and read-only devices.
##########################################################################################

SKIPUNZIP=1

ui_print " "
ui_print "Bootanimation template"
ui_print " ------------------"
ui_print " You can use @bootanimations_bot on telegram to create modules using your own videos"
ui_print " "

ui_print "- Extracting payload"
unzip -o "$ZIPFILE" 'module.prop' 'common/*' -d "$TMPDIR" >&2 || abort "! Cannot extract module payload"

# SKIPUNZIP=1 disables the installer default extraction, so restore module metadata
# explicitly. Without this file, Magisk cannot identify the installed module.
cp -f "$TMPDIR/module.prop" "$MODPATH/module.prop" || abort "! Cannot install module.prop"
set_perm "$MODPATH/module.prop" 0 0 0644

BA_SRC="$TMPDIR/common/bootanimation.zip"
if [ ! -f "$BA_SRC" ]; then
    abort "! No bootanimation.zip found in module. Place it at common/bootanimation.zip"
fi
if ! unzip -t "$BA_SRC" >/dev/null 2>&1; then
    abort "! bootanimation.zip is corrupt or not a ZIP archive"
fi
if ! unzip -p "$BA_SRC" desc.txt >/dev/null 2>&1; then
    abort "! bootanimation.zip must contain desc.txt at its root"
fi

# Android and OEMs commonly use one of these locations. Existing files are preferred;
# the two fallback locations cover AOSP system-as-root and product-based ROMs when the
# original file is absent or hidden by a read-only/compressed system partition.
BA_MEDIA_PATHS="/system/media /product/media /system/product/media /system/vendor/media /vendor/media /odm/media /system/system_ext/media /system/car/media /system/miui/media"
DETECTED_PATHS=""
for dir in $BA_MEDIA_PATHS; do
    if [ -f "$dir/bootanimation.zip" ] || [ -f "$dir/bootanimation-dark.zip" ]; then
        DETECTED_PATHS="$DETECTED_PATHS $dir"
    fi
done
case " $DETECTED_PATHS " in *" /system/media "*) ;; *) DETECTED_PATHS="$DETECTED_PATHS /system/media" ;; esac
case " $DETECTED_PATHS " in *" /product/media "*) ;; *) DETECTED_PATHS="$DETECTED_PATHS /product/media" ;; esac

ui_print "- Installing overlay files"
for dir in $DETECTED_PATHS; do
    mkdir -p "$MODPATH$dir" || abort "! Cannot create overlay path: $dir"
    cp -f "$BA_SRC" "$MODPATH$dir/bootanimation.zip" || abort "! Cannot install animation at: $dir"
    [ -f "$dir/bootanimation-dark.zip" ] && cp -f "$BA_SRC" "$MODPATH$dir/bootanimation-dark.zip"
    if [ -f "$TMPDIR/common/bootaudio.mp3" ]; then
        cp -f "$TMPDIR/common/bootaudio.mp3" "$MODPATH$dir/bootaudio.mp3"
    fi
    set_perm "$MODPATH$dir/bootanimation.zip" 0 0 0644
    [ -f "$MODPATH$dir/bootanimation-dark.zip" ] && set_perm "$MODPATH$dir/bootanimation-dark.zip" 0 0 0644
    [ -f "$MODPATH$dir/bootaudio.mp3" ] && set_perm "$MODPATH$dir/bootaudio.mp3" 0 0 0644
    ui_print "  Installed: $dir"
done

# --- Step 5: ROM-specific detection (informational) ---
MANUFACTURER=$(getprop ro.product.manufacturer 2>/dev/null | tr '[:upper:]' '[:lower:]')
case "$MANUFACTURER" in
    *xiaomi*)
        ui_print "- Xiaomi/MIUI: bootanimation.zip installed as fallback"
        ;;
    *samsung*)
        ui_print "- Samsung/OneUI: boot animation installed"
        ;;
esac

rm -rf "$TMPDIR/common"

ui_print " "
ui_print " Installation complete"
ui_print " Reboot to apply the new boot animation"
ui_print " "
ui_print " Support on telegram: @bootanimations_group"
