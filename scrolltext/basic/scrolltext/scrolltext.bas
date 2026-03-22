10 REM === MicroBeast LED Demo - Step 4: Scrolling Text ===
20 REM Prompts for a string and scrolls it continuously across the
30 REM 24-character LED display. Padded with spaces so text scrolls
40 REM in from the right and out to the left.
50 REM
60 REM --- Set up machine code stub at 60000 (&HEA60) ---
70 REM CALL S%(BM%, C%) passes HL=&bitmask, DE=&column
80 S% = 60000
90 FOR I% = 0 TO 10: READ V%: POKE S%+I%, V%: NEXT I%
120 REM
130 REM --- Read font data into array (ASCII 32-126) ---
140 DIM FT%(94)
150 FOR I% = 0 TO 94: READ FT%(I%): NEXT I%
160 REM
170 REM --- Get user input ---
180 INPUT "Enter scroll text: ", T$
200 REM
210 REM --- Build padded buffer: 24 spaces + text + 24 spaces ---
220 P$ = "                        ": REM 24 spaces
230 B$ = P$ + T$ + P$
240 BL% = LEN(B$)
250 REM
260 REM --- Scroll loop ---
270 REM Total scroll positions = length of buffer - 23
280 PRINT "Scrolling... press Ctrl-C to stop"
290 OF% = 1: REM scroll offset (1-based for MID$)
300 REM
310 REM Display 24 characters starting at offset
320 FOR C% = 0 TO 23
330   CH$ = MID$(B$, OF% + C%, 1)
340   IX% = ASC(CH$) - 32
350   IF IX% < 0 OR IX% > 94 THEN IX% = 0
360   BM% = FT%(IX%)
370   CALL S%(BM%, C%)
380 NEXT C%
420 REM
430 REM --- Delay for scroll speed ---
440 FOR D% = 1 TO 200: NEXT D%
450 REM
460 REM --- Advance scroll position, wrap around ---
470 OF% = OF% + 1
480 IF OF% > BL% - 23 THEN OF% = 1
490 GOTO 310
500 REM
510 REM --- MBB_WRITE_LED stub (11 bytes) ---
520 DATA &HEB, &H7E, &HEB, &H5E, &H23, &H56, &HEB, &HCD, &HD6, &HFD, &HC9
530 REM
540 REM --- Font DATA (ASCII 32-126, 95 entries) ---
550 DATA 0, 18688, 514, 4814, 4845, 11748
560 DATA 2905, 512, 3072, 8448, 16320, 4800
570 DATA 8192, 192, 16384, 9216
580 DATA 9279, 1030, 219, 143, 230, 2153
590 DATA 253, 5121, 255, 239, 64, 8704
600 DATA 3136, 200, 8576, 20611
610 DATA 699, 247, 4751, 57, 4623, 121
620 DATA 113, 189, 246, 4617, 30, 3184
630 DATA 56, 1334, 2358, 63
640 DATA 243, 2111, 2291, 237, 4609, 62
650 DATA 9264, 10294, 11520, 238, 9225
660 DATA 57, 2304, 15, 10240, 8
670 DATA 256, 8332, 2168, 216, 8334, 8280
680 DATA 5312, 1166, 4208, 4096, 8720
690 DATA 7680, 4608, 4308, 4176, 220
700 DATA 368, 1158, 80, 2184, 120
710 DATA 28, 8208, 10260, 11520, 654
720 DATA 8264, 8521, 4608, 3209, 9408
