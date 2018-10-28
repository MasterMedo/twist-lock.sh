#!/bin/bash
# dependencies: i3lock, scrot, imagemagick, xorg-xbacklight (xbacklight)

start=`date +%s%N`
# choose where the image will be temporarily stored
img=/tmp/i3lock.png

# take screenshot
scrot -z $img # 0.205 sec

# possible effects that can be applied to the image
sample="sample 352x240 -sample 1920x1080" 									# 0.262 sec
pixelate="scale 10% -scale 1000%" 													# 0.277 sec
spread="spread 5" 																					# 1.012 sec
swirl="bordercolor Black -border 100 -swirl 300 -shave 100"	# 1.085 sec
blur="blur 18,5" 																						# 1.514 sec
accent="-contrast-stretch 2%" 															# always on
darken="-fill black -colorize 25%"													# always on

# list of chosen effects to be applied to the image
effects=(	"${sample}" "${pixelate}" "${spread}" "${swirl}" "${blur}" ) # all effects
# effects=( "${sample}" "${pixelate}" ) # fast effects

# random effect from the list of chosen effects
effect=-$(shuf -n1 -e "${effects[@]}") # 0.00127 sec
# effect="${sample}" # specific effect

# apply effect on the image
convert $img $effect $accent $darken $img

# get current screen brightness
screen_brightness=$(xbacklight -get) # 0.00225 sec

# lower screen brightness by 80%
xbacklight -dec 80 & # 0.00063 sec

# create the image overlay and locking the screen
i3lock -nuef -i $img # [0.05, 0.08] sec, depends on size

# return screen brightness to what it was
xbacklight -set $screen_brightness -time 500 &

# remove the image after the screen has been unlocked
rm $img

# get image brightness - possible later use for darkening or brightening the image
# img_brightness=$(convert $img -colorspace Gray -format "%[fx:image.mean]" info:)

# used for time measurement
# start=`date +%s%N`
# end=`date +%s%N`
# echo $((end-start))
