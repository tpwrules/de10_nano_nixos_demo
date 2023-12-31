final: prev: {
  quartus-prime-lite = final.callPackage ./packages/quartus-prime {
    supportedDevices = [ "Cyclone V" ];
  };

  intel-socfpga-hwlib = final.callPackage ./packages/intel-socfpga-hwlib {};

  design = prev.lib.makeScope prev.newScope (self: with self; {
    soc_system = callPackage ./design/soc_system {};
    amaranth_top = callPackage ./design/amaranth_top {};
    bitstream = callPackage ./design/bitstream {};
    linux_firmware = callPackage ./design/linux_firmware {};
    application = final.pkgsCross.armv7l-hf-multiplatform.pkgsStatic.design.callPackage ./design/application {
      # TODO: fix cross logic so this is unnecessary
      inherit (final) quartus-prime-lite;
      soc_system = final.design.soc_system;
    };
  });
}
