;
; 64-entry sine table for brightness effects
;
; Values range from 4 to 124, within the MicroBeast LED brightness range (0-128).
; Formula: round(64 + 60 * sin(2 * pi * i / 64)) for i = 0..63
;
; Use with: AND 63 on the index for modulo-64 wraparound
;

sine64:
    db      64, 70, 76, 82, 88, 93, 98, 103
    db      107, 111, 114, 117, 119, 121, 123, 124
    db      124, 124, 123, 121, 119, 117, 114, 111
    db      107, 103, 98, 93, 88, 82, 76, 70
    db      64, 58, 52, 46, 40, 35, 30, 25
    db      21, 17, 14, 11, 9, 7, 5, 4
    db      4, 4, 5, 7, 9, 11, 14, 17
    db      21, 25, 30, 35, 40, 46, 52, 58
