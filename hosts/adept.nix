{
  lib,
  pkgs,
  stdenv,
  ...
}:

stdenv.mkDerivation rec {
  pname = "Adept";
  version = "2.30.1";

  meta = {
    description = "Communicate with Digilent system boards";
    homepage = "https://digilent.com/reference/software/adept/start";
    license = [ ]; # lib.licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };

  src = pkgs.requireFile rec {
    name = "digilent.adept.runtime_${version}_amd64.deb";
    hash = "sha256-5eUdJkDC/zTvO0NvO983g4EgsVFg1z37q4LpB3O2s3I=";
    message = ''
      Please download Adept ${version} 64-bit .deb and add it to the nix store using
      nix-prefetch-url file://$PWD/${name}.deb
    '';
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    binutils
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib

    avahi
    libusb1
    openssl
  ];

  unpackPhase = ''
    ar x $src
    tar -xf data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/digilent $out/share
    cp -r usr/lib/udev/* $out/bin
    cp -r usr/lib/digilent/adept/* $out/lib
    cp -r usr/share/* $out/share
  '';
}
