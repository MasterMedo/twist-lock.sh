#!/bin/bash

# Dependencies: i3lock, scrot, imagemagick, xorg-xbacklight (xbacklight)

# Choose where the image will be temporarily stored
IMAGE=/tmp/i3lock.png

# Take screenshot
scrot -z $IMAGE

# Possible effects that can be applied to the image
BLUR="blur 18,5"
PIXELATE="scale 10% -scale 1000%"
SWIRL="bordercolor Black -border 100 -swirl 300 -shave 100"
SPREAD="spread 5"
ACCENT="-contrast-stretch 2%" 			# Always on
DARKEN="-fill black -colorize 25%"	# Always on

# List of chosen effects to be applied to the image
EFFECTS=(	"${BLUR}" "${PIXELATE}" "${SWIRL}" "${SPREAD}" )

# Random effect from list of chosen effects
EFFECT=$(shuf -n1 -e "${EFFECTS[@]}")

# Applying the random effect, accent and dimming on the taken screenshot
convert $IMAGE -$EFFECT $ACCENT $DARKEN $IMAGE

# Get current screen brightness
screen_brightness=$(xbacklight -get)

# Lower screen brightness by 80%
xbacklight -dec 80 -time 500 &

# Creating the image overlay and locking the screen
i3lock -nuef -i $IMAGE

# Return screen brightness to what it was
xbacklight -set $screen_brightness -time 1000 &

# Removing the image after the screen has been unlocked
rm $IMAGE

# Get image brightness - possible later use for darkening or brightening the image
# img_brightness=$(convert $IMAGE -colorspace Gray -format "%[fx:image.mean]" info:)

