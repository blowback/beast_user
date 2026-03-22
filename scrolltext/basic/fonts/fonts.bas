10 REM === MicroBeast LED Demo - Step 2: Font Rendering ===
20 REM Display "HELLO" on the last 5 LED positions (columns 19-23)
30 REM using font bitmask data for the 14-segment displays.
40 REM
50 REM Each character has a 16-bit bitmask:
60 REM   Low byte  = outer segments (a,b,c,d,e,f,g1,g2)
70 REM   High byte = inner/diagonal segments (h,j,k,l,m,n)
80 REM
90 REM Font table is indexed from ASCII 32 (space) onwards.
100 REM Lookup: index = ASC(char) - 32, bitmask = FT%(index)
110 REM
120 REM --- Set up machine code stub at 60000 (&HEA60) ---
130 REM CALL S%(BM%, CO%) passes HL=&bitmask, DE=&column
140 S% = &HEA60
150 FOR I% = 0 TO 10: READ V%: POKE S%+I%, V%: NEXT I%
190 REM
200 REM --- Read font data into array ---
210 REM 95 entries: ASCII 32 (space) through ASCII 126 (~)
220 DIM FT%(94)
230 FOR I% = 0 TO 94
240   READ FT%(I%)
250 NEXT I%
260 REM
270 REM --- Display "HELLO" on columns 19-23 ---
280 H$ = "HELLO"
290 FOR I% = 1 TO 5
300   C$ = MID$(H$, I%, 1)
310   IX% = ASC(C$) - 32
320   BM% = FT%(IX%)
330   CO% = 18 + I%
340   CALL S%(BM%, CO%)
350 NEXT I%
400 REM
410 PRINT "Displayed HELLO on columns 19-23"
420 END
430 REM
440 REM --- MBB_WRITE_LED stub (11 bytes) ---
450 DATA &HEB, &H7E, &HEB, &H5E, &H23, &H56, &HEB, &HCD, &HD6, &HFD, &HC9
460 REM
470 REM --- Font DATA (ASCII 32-126, 95 entries) ---
480 REM Each value is a 16-bit bitmask for the 14-segment display
490 REM
500 DATA 0, 18688, 514, 4814, 4845, 11748
510 DATA 2905, 512, 3072, 8448, 16320, 4800
520 DATA 8192, 192, 16384, 9216
530 DATA 9279, 1030, 219, 143, 230, 2153
540 DATA 253, 5121, 255, 239, 64, 8704
550 DATA 3136, 200, 8576, 20611
560 DATA 699, 247, 4751, 57, 4623, 121
570 DATA 113, 189, 246, 4617, 30, 3184
580 DATA 56, 1334, 2358, 63
590 DATA 243, 2111, 2291, 237, 4609, 62
600 DATA 9264, 10294, 11520, 238, 9225
610 DATA 57, 2304, 15, 10240, 8
620 DATA 256, 8332, 2168, 216, 8334, 8280
630 DATA 5312, 1166, 4208, 4096, 8720
640 DATA 7680, 4608, 4308, 4176, 220
650 DATA 368, 1158, 80, 2184, 120
660 DATA 28, 8208, 10260, 11520, 654
670 DATA 8264, 8521, 4608, 3209, 9408
