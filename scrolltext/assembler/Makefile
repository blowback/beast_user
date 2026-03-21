# MicroBeast LED Demo - Assembler Examples Makefile
# Builds all Z80 assembler examples as CP/M .com binaries using sjasmplus

ASM = sjasmplus
AFLAGS = -I.

TARGETS = leds/leds.com fonts/fonts.com strings/strings.com \
          scrolltext/scrolltext.com effects/effects.com

.PHONY: all clean

all: $(TARGETS)

leds/leds.com: leds/leds.asm bios.inc
	$(ASM) $(AFLAGS) --raw=$@ $<

fonts/fonts.com: fonts/fonts.asm bios.inc font.asm
	$(ASM) $(AFLAGS) --raw=$@ $<

strings/strings.com: strings/strings.asm bios.inc font.asm
	$(ASM) $(AFLAGS) --raw=$@ $<

scrolltext/scrolltext.com: scrolltext/scrolltext.asm bios.inc font.asm
	$(ASM) $(AFLAGS) --raw=$@ $<

effects/effects.com: effects/effects.asm bios.inc font.asm sine64.asm
	$(ASM) $(AFLAGS) --raw=$@ $<

clean:
	rm -f $(TARGETS)
