#!/bin/bash

# # original code from stack overflow
# ffmpeg -f x11grab -framerate 25 \
#     $(xwininfo | gawk 'match($0, /-geometry ([0-9]+x[0-9]+).([0-9]+).([0-9]+)/, a)\
#       { print "-video_size " a[1] " -i +" a[2] "," a[3] }') \
#     ~/Videos/$(date +%Y-%m-%d_%H-%M_%S).mp4

# # 1st code(gemini). Only records video from a selected range
# 
# #!/bin/bash
# 
# # Check if slop is installed, as it's required for region selection
# if ! command -v slop &> /dev/null
# then
#     echo "slop could not be found. Please install it with 'sudo apt install slop'."
#     exit
# fi
# 
# # Use slop to get the coordinates and dimensions of a selected region or window
# # The 's' flag forces selection mode for a screen area
# # The 'q' flag suppresses standard output, we only care about the variables
# selection=$(slop -f "%g" -o)
# 
# # Parse the output to get the geometry, offset from the top-left corner
# # Example output: 1920x1080+0+0
# geometry=$(echo "$selection" | cut -d'+' -f1)
# offset_x=$(echo "$selection" | cut -d'+' -f2)
# offset_y=$(echo "$selection" | cut -d'+' -f3)
# 
# # Build the ffmpeg command with the extracted values
# ffmpeg -f x11grab -framerate 25 -video_size "$geometry" -i "+$offset_x,$offset_y" ~/Videos/$(date +%Y-%m-%d_%H-%M_%S).mp4

# 2 code (gemini) optimized for mobiles(it says). Again only records video from a selected range
#
# #!/bin/bash
# 
# # Check if slop is installed. It's needed to select the recording area.
# if ! command -v slop &> /dev/null; then
#     echo "slop is not installed. Please install it with: sudo apt install slop"
#     exit 1
# fi
# 
# # Use slop to get the geometry of the selected area or window
# selection=$(slop -f "%g" -o)
# 
# # Parse the selection string to get geometry and offset
# geometry=$(echo "$selection" | cut -d'+' -f1)
# offset_x=$(echo "$selection" | cut -d'+' -f2)
# offset_y=$(echo "$selection" | cut -d'+' -f3)
# 
# # Record the screen with the selected geometry.
# # -framerate: Standard 30 fps is good for smoothness.
# # -c:v libx264: H.264 is the best for mobile and web compatibility.
# # -crf 18: This is a high-quality setting. Lower numbers mean better quality, higher means worse. 18 is a good balance, often considered visually lossless.
# # -pix_fmt yuv420p: Crucial for mobile compatibility.
# # -preset slow: Uses more CPU to produce a smaller, higher-quality file. This is better for platforms like WhatsApp.
# # -g 60: Keyframe interval, ensures a keyframe every 2 seconds for better seeking and playback.
# # -movflags +faststart: Puts video metadata at the start of the file for faster playback.
# 
# ffmpeg -f x11grab -framerate 30 -video_size "$geometry" -i "+$offset_x,$offset_y" \
#   -c:v libx264 -crf 18 -pix_fmt yuv420p -preset slow -g 60 -movflags +faststart \
#   ~/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4


# # script for recording video and internal audio. (gemini)

# #!/bin/bash

# A simple menu to choose the audio source
echo "Choose an audio recording option:"
echo "1. Record Internal Audio (from system speakers)"
echo "2. Record Microphone Audio"
echo "3. Record Both Internal Audio and Microphone"
echo "4. Record Video Only (No Audio)"

read -p "Enter your choice [1-4]: " choice

# Check if slop is installed. It's needed to select the recording area.
if ! command -v slop &> /dev/null; then
    echo "slop not found. Please install it with: sudo apt install slop"
    exit 1
fi

# Use slop to get the geometry of the selected area or window
selection=$(slop -f "%g" -o)

# Parse the selection string to get geometry, offset
geometry=$(echo "$selection" | cut -d'+' -f1)
offset_x=$(echo "$selection" | cut -d'+' -f2)
offset_y=$(echo "$selection" | cut -d'+' -f3)

# FFmpeg command base
FFMPEG_CMD="ffmpeg -probesize 10M -analyzeduration 10M -f x11grab -framerate 30 -video_size \"$geometry\" -i \"+$offset_x,$offset_y\""
OUTPUT_FILE="~/Videos/$(date +%Y-%m-%d_%H-%M_%S).mp4"
# Add a filter to ensure height and width are divisible by 2 for h264
VIDEO_FILTERS="-vf scale='trunc(iw/2)*2:trunc(ih/2)*2'"
VIDEO_PARAMS="-c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p"

# Add audio sources and parameters based on user's choice
case "$choice" in
    1) # Internal Audio
        FFMPEG_CMD="$FFMPEG_CMD -f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -c:a aac -b:a 192k"
        ;;
    2) # Microphone Audio (replace with your mic's name)
        FFMPEG_CMD="$FFMPEG_CMD -f pulse -i alsa_input.pci-0000_00_1f.3.analog-stereo -c:a aac -b:a 192k"
        ;;
    3) # Both Internal and Microphone (replace with your mic's name)
        FFMPEG_CMD="$FFMPEG_CMD -f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -f pulse -i alsa_input.pci-0000_00_1f.3.analog-stereo -filter_complex amerge -c:a aac -b:a 192k"
        ;;
    4) # No Audio
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Execute the command
eval "$FFMPEG_CMD $VIDEO_FILTERS $VIDEO_PARAMS $OUTPUT_FILE"
