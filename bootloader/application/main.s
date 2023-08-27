.globl _start

# registers r0-r3 are in some sense defined to carry certain info on
# entry to the preloader but they do not once we start off the FPGA?

_start:
  # extinguish last LED to show that we are now running
  ldr r4, =0xc0003000
  ldr r5, =0x3f
  str r5, [r4]

  # try to touch the flash at u-boot start to make sure all that stuff is
  # working
  ldr r5, =0xc1700000
  ldr r5, [r5]

  # extinguish second to last LED to show that succeeded and we didn't
  # hit an exception or whatever
  ldr r5, =0x1f
  str r5, [r4]

  # try to write to the on chip RAM to make sure that's working
  # set version field to nonzero so the on chip RAM structures aren't used
  ldr r5, =0xfffff008
  ldr r6, =1
  str r6, [r5]

  # extinguish third to last LED to show we survived that
  ldr r5, =0xf
  str r5, [r4]

  # copy program to on chip RAM
  ldr r5, =0xc1700000
  ldr r6, =0xFFFF0000
  # number of words
  ldr r7, =((65536-4096)/4)
_copy:
  ldr r4, [r5], #4
  str r4, [r6], #4
  subs r7, r7, #1
  bne _copy

  # extinguish fourth to last LED to show we survived the copy
  ldr r4, =0xc0003000
  ldr r5, =0x7
  str r5, [r4]

  # load initial registers with defined values in case preloader uses them
  ldr r0, =0xfffff000
  ldr r1, =0x1000
  ldr r2, =0
  ldr r3, =0

  # pet the watchdog
  ldr r4, =0xFFD0200C
  ldr r5, =0x76
  str r5, [r4]

  # jump to the loaded program
  ldr r4, =0xFFFF0000
  bx r4

  # extinguish fifth to last LED in case somehow that failed
  ldr r4, =0xc0003000
  ldr r5, =0x3
  str r5, [r4]

  # then just loop forever
  b .
