if [[ "$3" = *"ports"* ]]; then cp /opt/retropie/configs/ports/$1/retroarch_hdmi.cfg /opt/retropie/configs/ports/$1/retroarch.cfg; else cp /opt/retropie/configs/$1/retroarch_hdmi.cfg /opt/retropie/configs/$1/retroarch.cfg; fi > /dev/null
exit 1