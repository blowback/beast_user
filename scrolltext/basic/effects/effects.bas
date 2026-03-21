10 REM === MicroBeast LED Demo - Step 5: Sine Wave Brightness ===
20 REM Scrolling text with a sine-wave brightness effect.
30 REM The brightness wave scrolls independently of the text.
40 REM
50 REM --- Machine code stub for MBB_WRITE_LED at 60000 (&HEA60) ---
60 S = 60000
70 POKE S+0, &H2A: POKE S+1, &H6A: POKE S+2, &HEA: REM LD HL,(60010)
80 POKE S+3, &H3A: POKE S+4, &H6C: POKE S+5, &HEA: REM LD A,(60012)
90 POKE S+6, &HCD: POKE S+7, &HD6: POKE S+8, &HFD: REM CALL &HFDD6
100 POKE S+9, &HC9: REM RET
110 REM
120 REM --- Machine code stub for MBB_LED_BRIGHTNESS at 60020 (&HEA74) ---
130 REM   LD A,(60031)   ; brightness (&HEA7F)
140 REM   LD C,A         ; C = brightness
150 REM   LD A,(60032)   ; column (&HEA80)
160 REM   CALL &HFDD3    ; MBB_LED_BRIGHTNESS (A=column, C=brightness)
170 REM   RET
180 REM Stub is 11 bytes (60020-60030), params at 60031-60032
200 B = 60020
210 REM LD A,(&HEA7F) = 3Ah 7Fh EAh (brightness at 60031)
220 POKE B+0, &H3A: POKE B+1, &H7F: POKE B+2, &HEA
230 REM LD C,A = 4Fh (C = brightness)
240 POKE B+3, &H4F
250 REM LD A,(&HEA80) = 3Ah 80h EAh (column at 60032)
260 POKE B+4, &H3A: POKE B+5, &H80: POKE B+6, &HEA
270 REM CALL &HFDD3 = CDh D3h FDh
280 POKE B+7, &HCD: POKE B+8, &HD3: POKE B+9, &HFD
290 REM RET = C9h
300 POKE B+10, &HC9
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
660   HI = INT(BM / 256): LO = BM - HI * 256
670   POKE 60010, LO: POKE 60011, HI
680   POKE 60012, C
690   CALL 60000
700   REM Set brightness from sine table
710   SI = (C + BO) AND 63: REM modulo 64
720   POKE 60032, C: REM column
730   POKE 60031, SN(SI): REM brightness
740   CALL 60020
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
