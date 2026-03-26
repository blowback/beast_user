;
; MicroBeast LED Demo - Step 3: String Display
; Prompt the user for a string and display it on the 24-char LED display.
;
; Build: sjasmplus --raw=strings.com strings.asm
; Run:   strings.com under CP/M on MicroBeast
;

            ORG     100h

            INCLUDE "../bios.inc"

; --- Print prompt ---
            LD      DE, prompt
            LD      C, C_WRITESTR
            CALL    BDOS

; --- Read user input via BDOS function 10 (buffered input) ---
; Buffer format: byte 0 = max chars, byte 1 = chars read, bytes 2+ = string
            LD      DE, inbuf
            LD      C, C_READSTR
            CALL    BDOS

; --- Print newline ---
            LD      DE, crlf
            LD      C, C_WRITESTR
            CALL    BDOS

; --- Display string on LEDs ---
            LD      A, (inbuf+1)   ; number of characters read
            LD      B, A           ; B = string length
            LD      C, 0           ; C = current column (0-23)

; Loop through all 24 columns
disploop:
            LD      A, C
            CP      24             ; done all columns?
            JR      Z, done

            ; Check if we still have characters to display
            LD      A, C
            CP      B              ; column >= string length?
            JR      NC, blank      ; yes, write blank

            ; Look up character in font table
            LD      HL, inbuf+2
            LD      E, C
            LD      D, 0
            ADD     HL, DE         ; HL = address of character
            LD      A, (HL)        ; A = ASCII character

            ; Font lookup: index = (ASCII - 20h) * 2
            SUB     20h
            CP      95             ; valid range? (0-94)
            JR      NC, blank      ; invalid char, show blank
            ADD     A, A           ; * 2
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A           ; HL = bitmask
            JR      writled

blank:
            LD      HL, 0000h      ; blank (all segments off)

writled:
            LD      A, C           ; column number
            PUSH    BC             ; preserve B=length, C=column across BIOS call
            CALL    MBB_WRITE_LED
            POP     BC

            INC     C              ; next column
            JR      disploop

done:
            JP      P_TERMCPM

; --- Data ---
prompt:     DB      'Enter text (max 24 chars): $'
crlf:       DB      13, 10, '$'
inbuf:      DB      24              ; max 24 characters
            DB      0               ; chars read (filled by BDOS)
            DS      25              ; input buffer space (+1 for CR terminator)

            INCLUDE "../font.asm"
