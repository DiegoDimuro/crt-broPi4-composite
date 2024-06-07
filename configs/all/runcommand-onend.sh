# when exiting an emulator -- revert to 480i NTSC
sleep 1
if tvservice -s | grep -q NTSC; then tvservice -c "NTSC 4:3"; fi > /dev/null
