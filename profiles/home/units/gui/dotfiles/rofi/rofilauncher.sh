# Dependencies: hyprctl, jq
# Target surface coverage (1/5 = 0.2)
TARGET_COVERAGE=0.1

# Get active monitor name and resolution
ACTIVE_MON=$(hyprctl activeworkspace -j | jq -r '.monitor')
MON_DATA=$(hyprctl monitors -j | jq -r --arg name "$ACTIVE_MON" '.[] | select(.name == $name)')
WIDTH=$(echo "$MON_DATA" | jq -r '.width')
HEIGHT=$(echo "$MON_DATA" | jq -r '.height')

# Total screen area
AREA=$((WIDTH * HEIGHT))

# Target area = 20% of screen
TARGET_AREA=$(echo "$AREA * $TARGET_COVERAGE" | bc | awk '{printf "%d", $0}')

# Maintain a 16:9 aspect ratio for window
ASPECT_RATIO=$(echo "16 / 9" | bc -l)
WIN_HEIGHT=$(echo "sqrt($TARGET_AREA / $ASPECT_RATIO)" | bc -l)
WIN_WIDTH=$(echo "$WIN_HEIGHT * $ASPECT_RATIO" | bc -l)

# Round to integers
WIN_WIDTH_INT=$(printf "%.0f" "$WIN_WIDTH")
WIN_HEIGHT_INT=$(printf "%.0f" "$WIN_HEIGHT")

# Set font size based on width — tweak scale factor if needed
FONT_SIZE=$(echo "$WIN_WIDTH / 60" | bc)
FONT_SIZE_INT=$(printf "%.0f" "$FONT_SIZE")

# Debug (optional)
# echo "Resolution: ${WIDTH}x${HEIGHT}"
# echo "Window: ${WIN_WIDTH_INT}x${WIN_HEIGHT_INT}"
# echo "Font: ${FONT_SIZE_INT}pt"

# Launch rofi with dynamic theme overrides
rofi -show drun \
    -theme ~/.config/rofi/custom.rasi -show-icons \
    -theme-str "window { width: ${WIN_WIDTH_INT}px; height: ${WIN_HEIGHT_INT}px; } * { font: \"FiraCode Nerd Font Bold ${FONT_SIZE_INT}\"; }"
