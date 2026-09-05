{
  lib,
  pkgs,
  stdenv,
  ...
}:

stdenv.mkDerivation rec {
  pname = "Adept";
  version = "2.30.1";

  src = pkgs.fetchurl {
    url = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}_amd64.deb";
    hash = "sha256-5eUdJkDC/zTvO0NvO983g4EgsVFg1z37q4LpB3O2s3I=";
  };

  meta = {
    description = "Communicate with Digilent system boards";
    homepage = "https://digilent.com/reference/software/adept/start";
    license = [ ];
    platforms = [ "x86_64-linux" ];
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

    cp -r usr/lib/udev/* $out/bin/
    chmod +x $out/bin/dftdrvdtch

    cp -r usr/lib/digilent/adept/* $out/lib/digilent/
    cp -r usr/share/* $out/share/
  '';
}
