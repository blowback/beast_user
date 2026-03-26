;
; MicroBeast LED Demo - Step 4: Scrolling Text
; Scroll user-input text continuously across the 24-character LED display.
; Text is padded with 24 spaces on each side so it scrolls in and out.
;
; Build: sjasmplus --raw=scrolltext.com scrolltext.asm
; Run:   scrolltext.com under CP/M on MicroBeast
;

            ORG     100h

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
            ; Fill padbuf with 303 spaces (24 + 255 + 24)
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

            ; Copy user text into padbuf+24
            LD      A, (inbuf+1)   ; string length
            OR      A
            JR      Z, startscroll ; empty string, just scroll blanks
            LD      B, A           ; B = length (max 255)
            LD      HL, inbuf+2    ; source
            LD      DE, padbuf+24  ; destination (after 24 spaces)
copytxt:
            LD      A, (HL)
            LD      (DE), A
            INC     HL
            INC     DE
            DJNZ    copytxt

; Calculate number of scroll positions: textlen + 25 (16-bit)
startscroll:
            LD      A, (inbuf+1)
            LD      L, A
            LD      H, 0
            LD      BC, 25         ; + 24 + 1
            ADD     HL, BC
            LD      (buflen), HL

            LD      DE, scrollmsg
            LD      C, C_WRITESTR
            CALL    BDOS

; --- Main scroll loop ---
            LD      HL, 0
            LD      (scrollpos), HL

scrollloop:
; --- Display 24 characters from current scroll position ---
            LD      HL, (scrollpos)
            LD      DE, padbuf
            ADD     HL, DE         ; HL = start of visible window
            LD      (winptr), HL

            LD      C, 0           ; C = column counter (0-23)
disploop:
            LD      A, C
            CP      24
            JR      Z, dispdone

            ; Get character at window position
            LD      HL, (winptr)
            LD      E, C
            LD      D, 0
            ADD     HL, DE
            LD      A, (HL)        ; A = character

            ; Font lookup
            SUB     20h
            CP      95
            JR      C, validchar
            XOR     A              ; invalid -> space (index 0)
validchar:
            ADD     A, A           ; * 2
            LD      E, A
            LD      D, 0
            LD      HL, font
            ADD     HL, DE
            LD      A, (HL)
            INC     HL
            LD      H, (HL)
            LD      L, A           ; HL = bitmask

            LD      A, C           ; column
            PUSH    BC             ; preserve C=column across BIOS call
            CALL    MBB_WRITE_LED
            POP     BC

            INC     C
            JR      disploop

dispdone:
; --- Delay loop for scroll speed ---
            LD      HL, DELAY_COUNT
delay:
            DEC     HL
            LD      A, H
            OR      L
            JR      NZ, delay

; --- Check for keypress (BDOS function 11 = console status) ---
            LD      C, 11
            CALL    BDOS
            OR      A
            JR      NZ, exit       ; key pressed, exit

; --- Advance scroll position (16-bit) ---
            LD      HL, (scrollpos)
            INC     HL
            LD      DE, (buflen)
            OR      A              ; clear carry
            SBC     HL, DE         ; scrollpos - buflen
            JR      C, nowrap      ; if scrollpos < buflen, keep it
            LD      HL, 0          ; wrap to start
            JR      savescroll
nowrap:
            ADD     HL, DE         ; restore: HL = scrollpos (undo the SBC)
savescroll:
            LD      (scrollpos), HL
            JR      scrollloop

exit:
            ; Read the key to clear it
            LD      C, 1
            CALL    BDOS
            JP      P_TERMCPM

; --- Constants ---
DELAY_COUNT EQU     8000h          ; tune this for scroll speed

; --- Data ---
prompt:     DB      'Enter scroll text: $'
scrollmsg:  DB      'Scrolling... press any key to stop', 13, 10, '$'
crlf:       DB      13, 10, '$'

inbuf:      DB      255            ; max chars
            DB      0              ; chars read
            DS      256            ; input buffer (+1 for CR terminator)

scrollpos:  DW      0              ; current scroll offset (16-bit)
buflen:     DW      0              ; number of scroll positions (16-bit)
winptr:     DW      0              ; pointer to current window start

padbuf:     DS      303            ; 24 + 255 + 24

            INCLUDE "../font.asm"
