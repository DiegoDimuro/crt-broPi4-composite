python /opt/retropie/configs/all/retropie_bgm_v1.03.py > /dev/null &
if tvservice -s | grep NTSC; then emulationstation --no-exit --screensize 640 448 --screenoffset 38 16 \#auto; else emulationstation --no-exit \#auto; fi
