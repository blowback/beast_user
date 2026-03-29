;
; MicroBeast LED Demo - Step 5: Sine Wave Brightness Effect
; Scrolling text with a sine-wave brightness pattern that moves
; across the display at a different rate than the text scroll.
;
; Build: sjasmplus --raw=effects.com effects.asm
; Run:   effects.com under CP/M on MicroBeast
;

            ORG     0x100

            INCLUDE "../bios.inc"

; --- Print prompt ---
            LD      DE, prompt
            LD      C, C_WRITESTR
            CALL    BDOS

; --- Read user input ---
            LD      DE, inbuf
            LD      C, C_READSTR
            CALL    BDOS

            LD      DE, crlf
            LD      C, C_WRITESTR
            CALL    BDOS

; --- Build padded buffer: 24 spaces + text + 24 spaces ---
            LD      HL, padbuf
            LD      BC, 303
            LD      A, ' '
clrbuf:
            LD      (HL), A
            INC     HL
            DEC     BC
            LD      A, B
            OR      C
            LD      A, ' '
            JR      NZ, clrbuf

            LD      A, (inbuf+1)
            OR      A
            JR      Z, startloop
            LD      B, A
            LD      HL, inbuf+2
            LD      DE, padbuf+24
copytxt:
            LD      A, (HL)
            LD      (DE), A
            INC     HL
            INC     DE
            DJNZ    copytxt

startloop:
            ; Calculate scroll positions: textlen + 25 (16-bit)
            LD      A, (inbuf+1)
            LD      L, A
            LD      H, 0
            LD      BC, 25
            ADD     HL, BC
            LD      (buflen), HL

            LD      DE, scrollmsg
            LD      C, C_WRITESTR
            CALL    BDOS

            ; Initialize counters
            LD      HL, 0
            LD      (scrollpos), HL
            XOR     A
            LD      (brightpos), A
            LD      (framecnt), A

; --- Paint characters for current scroll position ---
painttext:
            LD      HL, (scrollpos)
            LD      DE, padbuf
            ADD     HL, DE
            LD      (winptr), HL

            LD      C, 0           ; column counter
paintloop:
            LD      A, C
            CP      24
            JR      Z, brightloop

            PUSH    BC

            LD      HL, (winptr)
            LD      E, C
            LD      D, 0
            ADD     HL, DE
            LD      A, (HL)        ; ASCII character

            SUB     0x20
            CP      95
            JR      C, validch
            XOR     A
validch:
            ADD     A, A
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A           ; HL = bitmask

            LD      A, C
            CALL    MBB_WRITE_LED

            POP     BC
            INC     C
            JR      paintloop

; --- Update brightness every frame ---
brightloop:
            LD      C, 0           ; column counter
brightcol:
            LD      A, C
            CP      24
            JR      Z, brightdone

            PUSH    BC

            LD      A, (brightpos)
            ADD     A, C           ; A = column + brightpos
            AND     63             ; modulo 64
            LD      E, A
            LD      D, 0
            LD      HL, sine64
            ADD     HL, DE
            LD      A, (HL)        ; A = brightness value

            LD      B, A           ; save brightness in B
            LD      A, C           ; A = column
            LD      C, B           ; C = brightness
            CALL    MBB_LED_BRIGHTNESS

            POP     BC
            INC     C
            JR      brightcol

brightdone:
; --- Delay ---
            LD      HL, DELAY_COUNT
delay:
            DEC     HL
            LD      A, H
            OR      L
            JR      NZ, delay

; --- Check for keypress ---
            LD      C, C_STAT
            CALL    BDOS
            OR      A
            JR      NZ, exit

; --- Advance brightness offset every frame ---
            LD      A, (brightpos)
            INC     A
            AND     63
            LD      (brightpos), A

; --- Advance text scroll every 4th frame ---
            LD      A, (framecnt)
            INC     A
            AND     3
            LD      (framecnt), A
            JR      NZ, brightloop ; no text change, just update brightness

            ; Advance scroll position (16-bit)
            LD      HL, (scrollpos)
            INC     HL
            LD      DE, (buflen)
            OR      A              ; clear carry
            SBC     HL, DE
            JR      C, nowrap
            LD      HL, 0
            JR      savescroll
nowrap:
            ADD     HL, DE         ; restore scrollpos
savescroll:
            LD      (scrollpos), HL
            JP      painttext

exit:
            ; Read key to clear it
            LD      C, C_READ
            CALL    BDOS
            JP      P_TERMCPM

; --- Constants ---
DELAY_COUNT EQU     0x4000          ; faster than scrolltext (brightness updates more often)

; --- Data ---
prompt:     DB      'Enter scroll text: $'
scrollmsg:  DB      'Scrolling with effects... press any key to stop', 13, 10, '$'
crlf:       DB      13, 10, '$'

inbuf:      DB      255
            DB      0
            DS      256            ; +1 for CR terminator

scrollpos:  DW      0              ; 16-bit scroll offset
brightpos:  DB      0
framecnt:   DB      0
buflen:     DW      0              ; 16-bit scroll position count
winptr:     DW      0

padbuf:     DS      303            ; 24 + 255 + 24

            INCLUDE "../font.asm"
            INCLUDE "../sine64.asm"
