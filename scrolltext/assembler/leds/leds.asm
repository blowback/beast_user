;
; MicroBeast LED Demo - Step 1: Raw Segment Control
; Turn ON all 14 segments of the last 4 LED positions (columns 20-23)
;
; Build: sjasmplus --raw=leds.com leds.asm
; Run:   leds.com under CP/M on MicroBeast
;

            ORG     0x100            ; CP/M .com file starts at 0x100

            INCLUDE "../bios.inc"

; All 14 segments ON = 0x3FFF
; Low byte (L) = FFh = outer segments all on
; High byte (H) = 0x3F = inner/diagonal segments all on

            LD      B, 20          ; start at column 20
loop:
            LD      HL, 0x3FFF      ; all segments ON
            LD      A, B           ; column number
            PUSH    BC             ; preserve B across BIOS call
            CALL    MBB_WRITE_LED  ; write bitmask to LED
            POP     BC

            INC     B              ; next column
            LD      A, B
            CP      24             ; done all 4 columns (20-23)?
            JR      NZ, loop

            ; Exit cleanly to CP/M
            JP      P_TERMCPM
