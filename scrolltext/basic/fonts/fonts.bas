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
500 DATA &H0000, &H4900, &H0202, &H12CE, &H12ED, &H2DE4
510 DATA &H0B59, &H0200, &H0C00, &H2100, &H3FC0, &H12C0
520 DATA &H2000, &H00C0, &H4000, &H2400
530 DATA &H243F, &H0406, &H00DB, &H008F, &H00E6, &H0869
540 DATA &H00FD, &H1401, &H00FF, &H00EF, &H0040, &H2200
550 DATA &H0C40, &H00C8, &H2180, &H5083
560 DATA &H02BB, &H00F7, &H128F, &H0039, &H120F, &H0079
570 DATA &H0071, &H00BD, &H00F6, &H1209, &H001E, &H0C70
580 DATA &H0038, &H0536, &H0936, &H003F
590 DATA &H00F3, &H083F, &H08F3, &H00ED, &H1201, &H003E
600 DATA &H2430, &H2836, &H2D00, &H00EE, &H2409
610 DATA &H0039, &H0900, &H000F, &H2800, &H0008
620 DATA &H0100, &H208C, &H0878, &H00D8, &H208E, &H2058
630 DATA &H14C0, &H048E, &H1070, &H1000, &H2210
640 DATA &H1E00, &H1200, &H10D4, &H1050, &H00DC
650 DATA &H0170, &H0486, &H0050, &H0888, &H0078
660 DATA &H001C, &H2010, &H2814, &H2D00, &H028E
670 DATA &H2048, &H2149, &H1200, &H0C89, &H24C0
