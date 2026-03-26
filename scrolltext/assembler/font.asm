;
; Font definition for MicroBeast 14-segment LED displays
;
; Extracted from the MicroBeast firmware repository:
; https://github.com/atoone/MicroBeast/blob/main/firmware/font.asm
;
; Copyright (c) 2023 Andy Toone for Feersum Technology Ltd.
;
; Part of the MicroBeast Z80 kit computer project. Support hobby electronics.
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;
; Font table: 16-bit bitmask per character, indexed by ASCII code.
; To look up a character:
;   1. Subtract 0x20 (space) from ASCII code
;   2. Multiply by 2 (each entry is a 16-bit word)
;   3. Add to font base address
;   4. Read 16-bit word into HL (L=outer segments, H=inner/diagonal)
;
; Format: .dw value  ; where low byte = outer segments, high byte = inner segments
;

INVALID_CHAR_BITMASK    EQU 0x04861

font:
                    dw      0x0000   ; (space)
                    dw      0x4900   ; !
                    dw      0x0202   ; "
                    dw      0x12CE   ; #
                    dw      0x12ED   ; $
                    dw      0x2DE4   ; %
                    dw      0x0B59   ; &
                    dw      0x0200   ; '
                    dw      0x0C00   ; (
                    dw      0x2100   ; )
                    dw      0x3FC0   ; *
                    dw      0x12C0   ; +
                    dw      0x2000   ; ,
                    dw      0x00C0   ; -
                    dw      0x4000   ; .
                    dw      0x2400   ; /

                    dw      0x243F   ; 0
                    dw      0x0406   ; 1
                    dw      0x00DB   ; 2
                    dw      0x008F   ; 3
                    dw      0x00E6   ; 4
                    dw      0x0869   ; 5
                    dw      0x00FD   ; 6
                    dw      0x1401   ; 7
                    dw      0x00FF   ; 8
                    dw      0x00EF   ; 9
                    dw      0x0040   ; :
                    dw      0x2200   ; ;
                    dw      0x0C40   ; <
                    dw      0x00C8   ; =
                    dw      0x2180   ; >
                    dw      0x5083   ; ?

                    dw      0x02BB   ; @
                    dw      0x00F7   ; A
                    dw      0x128F   ; B
                    dw      0x0039   ; C
                    dw      0x120F   ; D
                    dw      0x0079   ; E
                    dw      0x0071   ; F
                    dw      0x00BD   ; G
                    dw      0x00F6   ; H
                    dw      0x1209   ; I
                    dw      0x001E   ; J
                    dw      0x0C70   ; K
                    dw      0x0038   ; L
                    dw      0x0536   ; M
                    dw      0x0936   ; N
                    dw      0x003F   ; O

                    dw      0x00F3   ; P
                    dw      0x083F   ; Q
                    dw      0x08F3   ; R
                    dw      0x00ED   ; S
                    dw      0x1201   ; T
                    dw      0x003E   ; U
                    dw      0x2430   ; V
                    dw      0x2836   ; W
                    dw      0x2D00   ; X
                    dw      0x00EE   ; Y
                    dw      0x2409   ; Z
                    dw      0x0039   ; [
                    dw      0x0900   ; backslash
                    dw      0x000F   ; ]
                    dw      0x2800   ; ^
                    dw      0x0008   ; _

                    dw      0x0100   ; `
                    dw      0x208C   ; a
                    dw      0x0878   ; b
                    dw      0x00D8   ; c
                    dw      0x208E   ; d
                    dw      0x2058   ; e
                    dw      0x14C0   ; f
                    dw      0x048E   ; g
                    dw      0x1070   ; h
                    dw      0x1000   ; i
                    dw      0x2210   ; j
                    dw      0x1E00   ; k
                    dw      0x1200   ; l
                    dw      0x10D4   ; m
                    dw      0x1050   ; n
                    dw      0x00DC   ; o

                    dw      0x0170   ; p
                    dw      0x0486   ; q
                    dw      0x0050   ; r
                    dw      0x0888   ; s
                    dw      0x0078   ; t
                    dw      0x001C   ; u
                    dw      0x2010   ; v
                    dw      0x2814   ; w
                    dw      0x2D00   ; x
                    dw      0x028E   ; y
                    dw      0x2048   ; z
                    dw      0x2149   ; {
                    dw      0x1200   ; |
                    dw      0x0C89   ; }
                    dw      0x24C0   ; ~
                    dw      0x0000   ; DEL
