# change video mode to the desired one
until kill -0 $(pidof retroarch) 2> /dev/null; do
	sleep 0.1
done
sleep 0.5
# wait until retroarch video driver is initialized
while kill -0 $(pidof retroarch) 2> /dev/null; do
	sleep 0.1
	retroarch_log=/tmp/retroarch/retroarch.log
	vready=$(awk '/Found display driver:/ {t=$0}END{print t}' "$retroarch_log")
	if [ ! -z "$vready" ]; then break; fi > /dev/null
done
sleep 0.5
# change video mode on-the-fly
while kill -0 $(pidof retroarch) 2> /dev/null; do
	# retrieve the previously set video mode.
	svmode=$(cat /tmp/svmode)
	# store the current video mode.
	cvmode0=$(tvservice -s)
	cvmode1=${cvmode0##*[}
	cvmode1=${cvmode1%]*}
	cvmode2=${cvmode0##*,}
	# read retroarch log file to determine internal game resolution (if reported). currently, only playstation reports its resolution correctly.
	retroarch_log=/tmp/retroarch/retroarch.log
	vres=$(awk '/SET_GEOMETRY:/ {t=$0}END{print t}' "$retroarch_log")
	vres=${vres##*x}
	vres=${vres%,*}
	# determine if the current video mode is 240p or 480i.
	if [ $cvmode2 = "progressive" ]; then cvmode="$cvmode1 P"; else cvmode="$cvmode1"; fi > /dev/null
	# determine if 240p or 480i should be used based on retroarch reported vertical resolution.
	if [ $vres -le 300 ]; then dvmode="$cvmode1 P"; else dvmode="$cvmode1"; fi > /dev/null
	# mark vres variable as "empty" if retroarch reported resolution cannot be retrieved.
	if [ -z "$vres" ]; then vres="empty"; fi > /dev/null
	# if current video mode is different than desired video mode and vres isn't "empty", set the new video mode.
	if [ ! "$cvmode" = "$dvmode" ] && ! echo "$vres" | grep empty; then tvservice -c "$dvmode"; fi > /dev/null
	# if current video mode is different than set video mode and vres is "empty", use the previously set video mode.
	if [ ! "$cvmode" = "$svmode" ] && echo "$vres" | grep empty; then tvservice -c "$svmode"; fi > /dev/null
	sleep 0.03
done
