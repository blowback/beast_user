10 REM === MicroBeast LED Demo - Step 5: Sine Wave Brightness ===
20 REM Scrolling text with a sine-wave brightness effect.
30 REM The brightness wave scrolls independently of the text.
40 REM
50 REM --- Machine code stub for MBB_WRITE_LED at 60000 (&HEA60) ---
60 REM CALL S(BM, C) passes HL=bitmask, DE=column
70 S = 60000
80 POKE S+0, &H7B: REM LD A,E
90 POKE S+1, &HCD: POKE S+2, &HD6: POKE S+3, &HFD: REM CALL &HFDD6
100 POKE S+4, &HC9: REM RET
110 REM
120 REM --- Machine code stub for MBB_LED_BRIGHTNESS at 60005 (&HEA65) ---
130 REM CALL B(BR, C) passes HL=brightness, DE=column
140 REM   LD A,L          ; brightness into A
150 REM   LD C,A          ; C = brightness
160 REM   LD A,E          ; column into A
170 REM   CALL &HFDD3     ; MBB_LED_BRIGHTNESS
180 REM   RET
190 B = 60005
200 POKE B+0, &H7D: REM LD A,L
210 POKE B+1, &H4F: REM LD C,A
220 POKE B+2, &H7B: REM LD A,E
230 POKE B+3, &HCD: POKE B+4, &HD3: POKE B+5, &HFD: REM CALL &HFDD3
240 POKE B+6, &HC9: REM RET
350 REM
360 REM --- Read font data into array (ASCII 32-126) ---
370 DIM FT(94)
380 FOR I = 0 TO 94: READ FT(I): NEXT I
390 REM
400 REM --- Read sine table (64 entries, values 0-128) ---
410 DIM SN(63)
420 FOR I = 0 TO 63: READ SN(I): NEXT I
430 REM
440 REM --- Get user input ---
450 INPUT "Enter scroll text: ", T$
470 REM
480 REM --- Build padded buffer ---
490 P$ = "                        ": REM 24 spaces
500 B$ = P$ + T$ + P$
510 BL = LEN(B$)
520 REM
530 REM --- Scroll loop with brightness effect ---
540 PRINT "Scrolling with effects... press Ctrl-C to stop"
550 OF = 1: REM text scroll offset (1-based)
560 BO = 0: REM brightness wave offset
570 FC = 0: REM frame counter for text speed
580 REM
590 REM --- Display frame ---
600 FOR C = 0 TO 23
610   REM Look up character and write to LED
620   CH$ = MID$(B$, OF + C, 1)
630   IX = ASC(CH$) - 32
640   IF IX < 0 OR IX > 94 THEN IX = 0
650   BM = FT(IX)
660   CALL S(BM, C)
670   REM Set brightness from sine table
680   SI = (C + BO) AND 63: REM modulo 64
690   BR = SN(SI)
700   CALL B(BR, C)
750 NEXT C
760 REM
770 REM --- Advance brightness every frame, text every 3 frames ---
780 BO = (BO + 1) AND 63
790 FC = FC + 1
800 IF FC >= 3 THEN OF = OF + 1: FC = 0
810 IF OF > BL - 23 THEN OF = 1
820 REM
830 GOTO 600
840 REM
850 REM --- Font DATA (ASCII 32-126, 95 entries) ---
860 DATA 0, 18688, 514, 4814, 4845, 11748
870 DATA 2905, 512, 3072, 8448, 16320, 4800
880 DATA 8192, 192, 16384, 9216
890 DATA 9279, 1030, 219, 143, 230, 2153
900 DATA 253, 5121, 255, 239, 64, 8704
910 DATA 3136, 200, 8576, 20611
920 DATA 699, 247, 4751, 57, 4623, 121
930 DATA 113, 189, 246, 4617, 30, 3184
940 DATA 56, 1334, 2358, 63
950 DATA 243, 2111, 2291, 237, 4609, 62
960 DATA 9264, 10294, 11520, 238, 9225
970 DATA 57, 2304, 15, 10240, 8
980 DATA 256, 8332, 2168, 216, 8334, 8280
990 DATA 5312, 1166, 4208, 4096, 8720
1000 DATA 7680, 4608, 4308, 4176, 220
1010 DATA 368, 1158, 80, 2184, 120
1020 DATA 28, 8208, 10260, 11520, 654
1030 DATA 8264, 8521, 4608, 3209, 9408
1040 REM
1050 REM --- Sine table (64 entries, values 4-124) ---
1060 DATA 64, 70, 76, 82, 88, 93, 98, 103
1070 DATA 107, 111, 114, 117, 119, 121, 123, 124
1080 DATA 124, 124, 123, 121, 119, 117, 114, 111
1090 DATA 107, 103, 98, 93, 88, 82, 76, 70
1100 DATA 64, 58, 52, 46, 40, 35, 30, 25
1110 DATA 21, 17, 14, 11, 9, 7, 5, 4
1120 DATA 4, 4, 5, 7, 9, 11, 14, 17
1130 DATA 21, 25, 30, 35, 40, 46, 52, 58
