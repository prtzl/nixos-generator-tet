{
  config,
  pkgs,
  ...
}:

let
  rofipackage = pkgs.rofi;
  rofilauncher = pkgs.writeShellApplication {
    name = "rofilauncher";
    runtimeInputs = with pkgs; [
      rofipackage
      jq
      bc
    ];
    text = ''
      # 10% screen coverage of rofi launcher
      TARGET_COVERAGE=0.1

      # Current monitor size for scaling
      ACTIVE_MON=$(hyprctl activeworkspace -j | jq -r '.monitor')
      MON_DATA=$(hyprctl monitors -j | jq -r --arg name "$ACTIVE_MON" '.[] | select(.name == $name)')
      WIDTH=$(echo "$MON_DATA" | jq -r '.width')
      HEIGHT=$(echo "$MON_DATA" | jq -r '.height')

      AREA=$((WIDTH * HEIGHT))
      TARGET_AREA=$(echo "$AREA * $TARGET_COVERAGE" | bc | awk '{printf "%d", $0}')

      # maintain aspect ratio
      ASPECT_RATIO=$(echo "16 / 9" | bc -l)

      # window dimensions
      WIN_HEIGHT=$(echo "sqrt($TARGET_AREA / $ASPECT_RATIO)" | bc -l)
      WIN_WIDTH=$(echo "$WIN_HEIGHT * $ASPECT_RATIO" | bc -l)
      WIN_WIDTH_INT=$(printf "%.0f" "$WIN_WIDTH")
      WIN_HEIGHT_INT=$(printf "%.0f" "$WIN_HEIGHT")

      # font size
      FONT_SIZE=$(echo "$WIN_WIDTH / 60" | bc)
      FONT_SIZE_INT=$(printf "%.0f" "$FONT_SIZE")

      # run rofi with overrides
      rofi -show drun \
          -theme ${./dotfiles/rofi/myrofitheme.rasi} -show-icons \
          -theme-str "window { width: ''${WIN_WIDTH_INT}px; height: ''${WIN_HEIGHT_INT}px; } * { font: \"FiraCode Nerd Font Bold ''${FONT_SIZE_INT}\"; }"
    '';
  };
in
{
  home.packages = [ rofilauncher ];

  programs.rofi = {
    enable = true;
    package = rofipackage;
    theme = ./dotfiles/rofi/myrofitheme.rasi;
  };
}
