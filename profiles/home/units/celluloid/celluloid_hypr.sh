#!/usr/bin/env bash

# re-use celluloid in same WS or open new

file="${1:-}"
player="Celluloid"

ws=$(hyprctl activeworkspace -j | jq -r '.id')
client=$(hyprctl clients -j | jq -r ".[] | select((.class | contains(\"$player\")) and .workspace.id==$ws) | .address" | head -n1)

if [ -n "$client" ]; then
    # celluloid will by default re-use the last focused one
    hyprctl eval "hl.dispatch(hl.dsp.focus({ window = '$client' }))"
    # could use "--enqueue" if I wanted to add to playlist
    celluloid "$file"
else
    celluloid --new-window "$file"
fi
