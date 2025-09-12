options=("$@")

active=$(hyprshade current)
if [ -n "$active" ]; then
    hyprshade off
fi

# Somehow hyprshot returns 1 with -m output --clipboard-only
hyprshot "${options[@]}" || true

if [ -n "$active" ]; then
    hyprshade on "$active"
fi
