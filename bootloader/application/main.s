.globl _start

_start:
  # extinguish last LED to show that we are now running
  ldr r0, =0xc0003000
  ldr r1, =0x3f
  str r1, [r0]

  b .
