10 REM === MicroBeast LED Demo - Step 2: Font Rendering ===
20 REM Display "HELLO" on the last 5 LED positions (columns 19-23)
30 REM using font bitmask data for the 14-segment displays.
40 REM
50 REM Each character has a 16-bit bitmask:
60 REM   Low byte  = outer segments (a,b,c,d,e,f,g1,g2)
70 REM   High byte = inner/diagonal segments (h,j,k,l,m,n)
80 REM
90 REM Font table is indexed from ASCII 32 (space) onwards.
100 REM Lookup: index = ASC(char) - 32, bitmask = FT(index)
110 REM
120 REM --- Set up machine code stub at 60000 (&HEA60) ---
130 REM Same stub as leds.bas: loads HL and A, calls MBB_WRITE_LED
140 S = 60000
150 POKE S+0, &H2A: POKE S+1, &H6A: POKE S+2, &HEA: REM LD HL,(60010)
160 POKE S+3, &H3A: POKE S+4, &H6C: POKE S+5, &HEA: REM LD A,(60012)
170 POKE S+6, &HCD: POKE S+7, &HD6: POKE S+8, &HFD: REM CALL &HFDD6
180 POKE S+9, &HC9: REM RET
190 REM
200 REM --- Read font data into array ---
210 REM 95 entries: ASCII 32 (space) through ASCII 126 (~)
220 DIM FT(94)
230 FOR I = 0 TO 94
240   READ FT(I)
250 NEXT I
260 REM
270 REM --- Display "HELLO" on columns 19-23 ---
280 H$ = "HELLO"
290 FOR I = 1 TO 5
300   C$ = MID$(H$, I, 1)
310   IX = ASC(C$) - 32
320   BM = FT(IX)
330   REM Split 16-bit value into low and high bytes
340   HI = INT(BM / 256)
350   LO = BM - HI * 256
360   POKE 60010, LO: POKE 60011, HI
370   POKE 60012, 18 + I
380   CALL 60000
390 NEXT I
400 REM
410 PRINT "Displayed HELLO on columns 19-23"
420 END
430 REM
440 REM --- Font DATA (ASCII 32-126, 95 entries) ---
450 REM Each value is a 16-bit bitmask for the 14-segment display
460 REM
470 DATA 0, 18688, 514, 4814, 4845, 11748
480 DATA 2905, 512, 3072, 8448, 16320, 4800
490 DATA 8192, 192, 16384, 9216
500 DATA 9279, 1030, 219, 143, 230, 2153
510 DATA 253, 5121, 255, 239, 64, 8704
520 DATA 3136, 200, 8576, 20611
530 DATA 699, 247, 4751, 57, 4623, 121
540 DATA 113, 189, 246, 4617, 30, 3184
550 DATA 56, 1334, 2358, 63
560 DATA 243, 2111, 2291, 237, 4609, 62
570 DATA 9264, 10294, 11520, 238, 9225
580 DATA 57, 2304, 15, 10240, 8
590 DATA 256, 8332, 2168, 216, 8334, 8280
600 DATA 5312, 1166, 4208, 4096, 8720
610 DATA 7680, 4608, 4308, 4176, 220
620 DATA 368, 1158, 80, 2184, 120
630 DATA 28, 8208, 10260, 11520, 654
640 DATA 8264, 8521, 4608, 3209, 9408
