# Interesting info

## CSM might break GPU

Somehow having CSM enabled (so that I could boot from USB and install OS) the GPU (Intel ARC B580 nitro) could not allocate more than 256MB of memory (out of 16GB).
OBS would core dump, steam would login but then "loop" the main GUI. There would be tray icon but no GUI.

Interesting is that I went back to nixpkgs (and home-manager) to around 1.9.2025 version (3.10.2025 now) with kernel 6.16.0 and it would work even with CSM enabled.
Somehow somewhere on forum I found issue related to GPU issue allocating memory and CSM was mentioned. WHY OH WHY.

## Intel ARC B580 output broken on 6.16.9 (6.16.8 works) (6.17 WORKS!!!, update people!)

Also, not working on current nixos latest kernel 6.16.9, GPU output is broken (works, but no image - light grey color).
Going one minor version back works, steam launches, everyone is happy.
