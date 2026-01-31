#!/bin/bash

# A simple way to check if a display is connected
connected=$(xrandr | grep -c " connected")

# If only the laptop screen is connected, ensure it's the primary
if [ "$connected" -eq 1 ]; then

    echo "Only the laptop screen is connected. Setting it as primary."

    xrandr --output eDP-1 --primary --auto --pos 0x0
    xrandr --output DP-2 --off
    xrandr --output HDMI-1 --off

    exit 0
fi

# Find the connected external monitor
if xrandr | grep "DP-1 connected"; then
    EXTERNAL_MONITOR="DP-1"
elif xrandr | grep "DP-2 connected"; then
    EXTERNAL_MONITOR="DP-2"
elif xrandr | grep "HDMI-1 connected"; then
    EXTERNAL_MONITOR="HDMI-1"
elif xrandr | grep "HDMI-2 connected"; then
    EXTERNAL_MONITOR="HDMI-2"
else 
    # Runs if connected > 1 
    echo "Warning: multiple displays detected"
    exit 1
fi

echo "Connected displays: Laptop (eDP-1) and external ($EXTERNAL_MONITOR)."
echo "Enter a display setup (Mirrored(m) or Extended(e)): "
read DSETTING
# Convert input to lowercase
DSETTING=$(echo "$DSETTING" | tr '[:upper:]' '[:lower:]')


# Set the external monitor to extended
if [[ "$DSETTING" == 'e' ]]; then

    echo "Configuring extended display"

    # Set Laptop (Primary) and place External monitor to the right
    xrandr --output eDP-1 --primary --auto --pos 0x0
    xrandr --output "$EXTERNAL_MONITOR" --auto --right-of eDP-1

    # Turn off the other unused external output
    if [ "$EXTERNAL_MONITOR" = "DP-2" ]; then
        xrandr --output HDMI-1 --off
    else
        xrandr --output DP-2 --off
    fi


# Set the laptop and external monitor to mirrored
elif [[ "$DSETTING" == 'm' ]]; then
    echo "Configuring mirrored display"

    xrandr --output eDP-1 --primary --auto --pos 0x0
    xrandr --output "$EXTERNAL_MONITOR" --auto --same-as eDP-1

    # Turn off the other unused external output
    if [ "$EXTERNAL_MONITOR" = "DP-2" ]; then
        xrandr --output HDMI-1 --off
    else
        xrandr --output DP-2 --off
    fi

else
    echo "Invalid setting entered. Please enter 'm' or 'e'."
    exit 1
fi

echo "Display configuration complete."
