#!/usr/bin/env bash

host=$1
diskodir="./hosts/${host}"

if [[ "$host" == "" ]]; then
    echo "Host not defined!"
    exit 1
fi

if [ ! -d "$diskodir" ]; then
    echo "Host $host does not have a configuration directory: $diskodir !"
    exit 1
fi

diskofile="${diskodir}/disko.nix"

if [ ! -f "$diskofile" ]; then
    echo "Disko configuration file for host $host does not exist: $diskofile"
    exit 1
fi

sudo nix --experimental-features "nix-command flakes" run .#disko -- --mode destroy,format,mount $diskofile

read -r -p "Successfully formatted and mounted the drive. Do you want to install $host? [y/yes]" answer
if [[ "$answer" == [yY] ]]; then
    sudo nixos-install --flake .#${host}
else
    echo "Install canceled!"
fi
