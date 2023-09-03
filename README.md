## U-Boot in Active Serial DE-10 Nano Demo

MINOR FLAW: U-Boot will not start without an SD card present as the boot ROM won't fall back to the FPGA otherwise

FATAL FLAW: Setting MSEL to boot from Active Serial prevents the HPS from reconfiguring the FPGA ever (unless it reprograms the flash which is not yet possible)

1. Set MSEL switches to Up, Down, Up, Up, Down, Up from left to right
2. `nix build .#bootloader.flash_image` and use Quartus Programmer to USB blast `result/quartus.jic`
3. `nix build .#nixosConfigurations.de10-nano` and extract/dd `result/sd-image/*.img.zst` to your SD card
4. Plug in and power on and access console over USB UART
