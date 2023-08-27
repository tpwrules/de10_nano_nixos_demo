#
TARGET = hps_boot_memory.hex

#
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-
# text start address is 0xC000_0000 as that's where the HPS is hard-coded to boot from the FPGA
CFLAGS = -g -Wall   -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)   -I$(HWLIBS_ROOT)/include/ -nostdlib -nostartfiles -ffreestanding -Ttext=0xc0000000
# dump .text to output address 0
OBJCOPYFLAGS =  -O ihex -j .text --change-section-lma .text=0
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
ARCH= arm

build: $(TARGET)
$(TARGET): main.elf
	$(OBJCOPY) $(OBJCOPYFLAGS)  $^ $@
%.elf : %.s
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ *.elf
