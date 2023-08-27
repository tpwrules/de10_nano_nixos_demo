{ stdenvNoCC
, lib
, quartus-prime-lite
, soc_system
, application
}:

stdenvNoCC.mkDerivation {
  name = "bitstream";

  src = lib.sources.sourceByRegex ./../../../bootloader/bitstream [
    "ip/?[^.]*"
    "ip/.*\.qip$"
    "ip/.*\.v$"
    "[^/]*\.qpf$"
    "[^/]*\.qsf$"
    "[^/]*\.sdc$"
    "[^/]*\.v$"
    "[^/]*\.tcl$"
  ];

  postUnpack = ''
    cp -r ${soc_system}/* source/
    chmod -R u+w source/
  '';

  buildPhase = ''
    runHook preBuild

    cp ${application}/*.hex soc_system/synthesis/submodules/soc_system_hps_boot_memory.hex
    ${quartus-prime-lite}/bin/quartus_sh --flow compile *.qpf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.sof $out/bitstream.sof

    runHook postInstall
  '';
}
