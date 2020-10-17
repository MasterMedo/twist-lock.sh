#!/bin/bash
# dependencies: i3lock, scrot, imagemagick, xorg-xbacklight (xbacklight)

# choose where the image will be temporarily stored
img=/tmp/i3lock.png

# take screenshot
maim -B $img

# possible effects that can be applied to the image
sample="sample 352x240 -sample 1920x1080"
pixelate="scale 10% -scale 1000%"
spread="spread 5"
swirl="bordercolor Black -border 100 -swirl 380 -implode 0.3 -shave 100"
blur="filter Gaussian -resize 50% -define filter:sigma=3 -resize 200%"
accent="-contrast-stretch 2%"
colorize="-fill orange -colorize 25%"

# list of chosen effects to be applied to the image
effects=( "${sample}" "${pixelate}" "${spread}" "${swirl}" "${blur}" ) # all effects
#effects=( "${sample}" "${pixelate}" ) # fast effects
#effects=( "${swirl}" ) # test effects

# random effect from the list of chosen effects
effect=-$(shuf -n1 -e "${effects[@]}")

# apply effect on the image
convert $img $effect $accent $colorize $img

# get current screen brightness
screen_brightness=$(xbacklight -get)

# set screen brightness to 20%
xbacklight -set 20 &

# create the image overlay and locking the screen
i3lock -nuef -t -i $img

# return screen brightness to what it was
xbacklight -set $screen_brightness -time 500 &

# remove the image after the screen has been unlocked
rm $img

# get image brightness - possible later use for darkening or brightening the image
# img_brightness=$(convert $img -colorspace Gray -format "%[fx:image.mean]" info:)

# used for time measurement
#start=`date +%s%N`
#end=`date +%s%N`
#echo $((end-start))
