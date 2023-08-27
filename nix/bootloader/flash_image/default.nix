{ stdenv
, lib
, pkgsCross
, quartus-prime-lite
, bitstream
, application
}:

let
  uboot = pkgsCross.armv7l-hf-multiplatform.buildUBoot {
    defconfig = "socfpga_de10_nano_defconfig";
    filesToInstall = ["u-boot-with-spl.sfp"];
    # automatically boot by default
    extraConfig = ''
      CONFIG_USE_BOOTCOMMAND=y
    '';
  };
in stdenv.mkDerivation {
  name = "flash_image";

  src = lib.sources.sourceByRegex ./../../../bootloader/bitstream [
    "[^/]*\.cof$"
  ];

  nativeBuildInputs = [ quartus-prime-lite ];

  postUnpack = ''
    cp -r ${bitstream}/* source/
    chmod -R u+w source/
  '';

  buildPhase = ''
    runHook preBuild

    objcopy -I binary -O ihex ${uboot}/u-boot-with-spl.sfp u-boot-with-spl.hex
    quartus_cpf -c *.cof
    cat *.map
    echo

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.jic $out/quartus.jic

    runHook postInstall
  '';
}
