;
; MicroBeast LED Demo - Step 2: Font Rendering
; Display "HELLO" on the last 5 LED positions (columns 19-23)
; using the font table to look up 14-segment bitmasks.
;
; Build: sjasmplus --raw=fonts.com fonts.asm
; Run:   fonts.com under CP/M on MicroBeast
;

            ORG     100h

            INCLUDE "../bios.inc"

; --- Display "HELLO" on columns 19-23 ---
; For each character:
;   1. Get ASCII code
;   2. Subtract 20h (space) to get font table index
;   3. Multiply by 2 (each entry is a 16-bit word)
;   4. Add font table base address
;   5. Load 16-bit bitmask from table into HL
;   6. Set A = column number
;   7. Call MBB_WRITE_LED

            ; 'H' = 48h, column 19
            LD      A, 'H' - 20h   ; font index for 'H'
            ADD     A, A            ; multiply by 2 (word size)
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE          ; HL = address of bitmask for 'H'
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A            ; HL = bitmask
            LD      A, 19           ; column 19
            CALL    MBB_WRITE_LED

            ; 'E' = 45h, column 20
            LD      A, 'E' - 20h
            ADD     A, A
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A
            LD      A, 20
            CALL    MBB_WRITE_LED

            ; 'L' = 4Ch, column 21
            LD      A, 'L' - 20h
            ADD     A, A
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A
            LD      A, 21
            CALL    MBB_WRITE_LED

            ; 'L' = 4Ch, column 22
            LD      A, 'L' - 20h
            ADD     A, A
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A
            LD      A, 22
            CALL    MBB_WRITE_LED

            ; 'O' = 4Fh, column 23
            LD      A, 'O' - 20h
            ADD     A, A
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A
            LD      A, 23
            CALL    MBB_WRITE_LED

            JP      P_TERMCPM

            INCLUDE "../font.asm"
