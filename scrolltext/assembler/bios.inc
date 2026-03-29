;
; MicroBeast BIOS entry points and CP/M constants
; For use with LED demo tutorial examples
;

; --- MicroBeast BIOS routines ---

; Write bitmask to LED display
;   HL = Bit pattern (L=outer segments, H=inner/diagonal)
;   A  = Column (0-23)
MBB_WRITE_LED       EQU     0FDD6h

; Set LED column brightness
;   A  = Column (0-23)
;   C  = Brightness (0-128)
MBB_LED_BRIGHTNESS  EQU     0FDD3h

; --- CP/M BDOS ---

BDOS                EQU     0005h       ; BDOS entry point
P_TERMCPM           EQU     0           ; Warm boot / program exit
C_READ              EQU     1           ; Console input (wait for key, return in A)
C_WRITESTR          EQU     9           ; Print string (DE=address, '$' terminated)
C_READSTR           EQU     10          ; Buffered console input
C_STAT              EQU     11          ; Console status (A=0xFF if key ready)
