# A first demo project for MicroBeast - 

A follow-along first tutorial for new MicroBeast Users: people who have just built their microbeast kit and are wondering: now what?!

The demo takes them through displaying a scrolling text of their choice on the MicroBeast's 24-character 14 segment LED displays.

The demo is in two parts:

1) example in MicroSoft BASIC 80 (z80, cp/m)

2) example in z80 assembler, using sjasmplus

further parts may be added later, the same demo in different languages (Forth, perhaps).

## Hardware background

The MicroBeast is a Z80 8 MHz retrocomputer with 512k RAM and 512k FLASH (banked) - it runs CPM/2.2 and comes with a custom BIOS. The disk image
that the microbeast boots into includes Microsoft BASIC 80 (MBASIC.COM).

It has two LUMISIL IS31FL3733B 12x16 LED drivers, each driving a pair of HOUKEM-60401-AW 6-digit 14 segment displays, for a total of 24 characters.

## Firmware background

The firmware comes with an include file for its specific revision, e.g. `bios_1_7.inc`. This defines some well-known entry points for BIO routines,
including these routines of interest:

```
;
; CALL MBB_WRITE_LED - Directly write bitmask to LED display (Check Font editor online for bit order)
;   Parameters:
;       HL = Bit pattern to write to LED digit
;       A  = Column (0-23)
;
MBB_WRITE_LED           .EQU    0FDD6h

;
; CALL MBB_LED_BRIGHTNESS - Set segments in digit A to brightness C
;   Parameters:
;       A  = Column (0-23)
;       C  = Brightness (0-128)
;
MBB_LED_BRIGHTNESS      .EQU    0FDD3h
```

Sadly it does not include a hook to the function that can write an ASCII character to the display, nor does it expose the "font". However, the "font"
is published at https://github.com/atoone/MicroBeast/blob/main/firmware/font.asm so we can make our own copy.


## Structure of code examples

These are the code examples and the directory structure I would like you to create:

- /basic # examples in microsoft basic
  - /leds: controlling what an LED displays (turn all segments of last 4 LEDs ON)
  - /fonts: fonts, ASCII etc: include the "font" and write "HELLO" to last 5 LEDs individually / unrolled code
  - /strings: take an arbitrary user string and display (up to 24 chars) on LED
  - /scrolltext: take arbitary string and repeatedly scroll it across display at fixed speed, padding if necessary
  - /effects: augment scrolltext by having a sine wave brightness wave that scrolls across the text at a different rate
- /assembler # same examples, but in z80 assembler
  - /leds: controlling what an LED displays (turn all segments of last 4 LEDs ON)
  - /fonts: fonts, ASCII etc: include the "font" and write "HELLO" to last 5 LEDs individually / unrolled code
  - /strings: take an arbitrary user string and display (up to 24 chars) on LED
  - /scrolltext: take arbitary string and repeatedly scroll it across display at fixed speed, padding if necessary
  - /effects: augment scrolltext by having a sine wave brightness wave that scrolls across the text at a different rate


