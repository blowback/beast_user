10 REM === MicroBeast LED Demo - Step 5: Sine Wave Brightness ===
20 REM Scrolling text with a sine-wave brightness effect.
30 REM The brightness wave scrolls independently of the text.
40 REM
50 REM --- Machine code stub for MBB_WRITE_LED at 60000 (&HEA60) ---
60 REM CALL S%(BM%, C%) passes HL=&bitmask, DE=&column
70 S% = &HEA60
80 FOR I% = 0 TO 10: READ V%: POKE S%+I%, V%: NEXT I%
90 REM
100 REM --- Machine code stub for MBB_LED_BRIGHTNESS at 60011 (&HEA6B) ---
110 REM CALL B%(BR%, C%) passes HL=&brightness, DE=&column
120 REM   EX DE,HL / LD A,(HL) / EX DE,HL / LD C,(HL) / CALL &HFDD3 / RET
130 B% = &HEA6B
140 FOR I% = 0 TO 7: READ V%: POKE B%+I%, V%: NEXT I%
350 REM
360 REM --- Read font data into array (ASCII 32-126) ---
370 DIM FT%(94)
380 FOR I% = 0 TO 94: READ FT%(I%): NEXT I%
390 REM
400 REM --- Read sine table (64 entries, values 0-128) ---
410 DIM SN%(63)
420 FOR I% = 0 TO 63: READ SN%(I%): NEXT I%
430 REM
440 REM --- Get user input ---
450 INPUT "Enter scroll text: ", T$
470 REM
480 REM --- Build padded buffer ---
490 P$ = "                        ": REM 24 spaces
500 B$ = P$ + T$ + P$
510 BL% = LEN(B$)
520 REM
530 REM --- Main loop ---
540 PRINT "Scrolling with effects... press Ctrl-C to stop"
550 OF% = 1: REM text scroll offset (1-based)
560 BO% = 0: REM brightness wave offset
570 FC% = 0: REM frame counter
580 REM
590 REM --- Paint characters (only when text offset changes) ---
600 FOR C% = 0 TO 23
610   CH$ = MID$(B$, OF% + C%, 1)
620   IX% = ASC(CH$) - 32
630   IF IX% < 0 OR IX% > 94 THEN IX% = 0
640   BM% = FT%(IX%)
650   CALL S%(BM%, C%)
660 NEXT C%
670 REM
680 REM --- Brightness loop (runs every tick) ---
690 FOR C% = 0 TO 23
700   SI% = (C% + BO%) AND 63
710   BR% = SN%(SI%)
720   CALL B%(BR%, C%)
730 NEXT C%
740 REM
750 REM --- Advance brightness every tick, text every 4th tick ---
760 BO% = (BO% + 1) AND 63
770 FC% = (FC% + 1) AND 3
780 IF FC% <> 0 THEN 690
790 OF% = OF% + 1
800 IF OF% > BL% - 23 THEN OF% = 1
810 GOTO 600
840 REM
845 REM --- MBB_WRITE_LED stub (11 bytes) ---
846 DATA &HEB, &H7E, &HEB, &H5E, &H23, &H56, &HEB, &HCD, &HD6, &HFD, &HC9
847 REM
848 REM --- MBB_LED_BRIGHTNESS stub (8 bytes) ---
849 DATA &HEB, &H7E, &HEB, &H4E, &HCD, &HD3, &HFD, &HC9
850 REM
851 REM --- Font DATA (ASCII 32-126, 95 entries) ---
860 DATA &H0000, &H4900, &H0202, &H12CE, &H12ED, &H2DE4
870 DATA &H0B59, &H0200, &H0C00, &H2100, &H3FC0, &H12C0
880 DATA &H2000, &H00C0, &H4000, &H2400
890 DATA &H243F, &H0406, &H00DB, &H008F, &H00E6, &H0869
900 DATA &H00FD, &H1401, &H00FF, &H00EF, &H0040, &H2200
910 DATA &H0C40, &H00C8, &H2180, &H5083
920 DATA &H02BB, &H00F7, &H128F, &H0039, &H120F, &H0079
930 DATA &H0071, &H00BD, &H00F6, &H1209, &H001E, &H0C70
940 DATA &H0038, &H0536, &H0936, &H003F
950 DATA &H00F3, &H083F, &H08F3, &H00ED, &H1201, &H003E
960 DATA &H2430, &H2836, &H2D00, &H00EE, &H2409
970 DATA &H0039, &H0900, &H000F, &H2800, &H0008
980 DATA &H0100, &H208C, &H0878, &H00D8, &H208E, &H2058
990 DATA &H14C0, &H048E, &H1070, &H1000, &H2210
1000 DATA &H1E00, &H1200, &H10D4, &H1050, &H00DC
1010 DATA &H0170, &H0486, &H0050, &H0888, &H0078
1020 DATA &H001C, &H2010, &H2814, &H2D00, &H028E
1030 DATA &H2048, &H2149, &H1200, &H0C89, &H24C0
1040 REM
1050 REM --- Sine table (64 entries, values 0-255) ---
1060 DATA &H0080, &H008C, &H0098, &H00A5, &H00B0, &H00BC, &H00C6, &H00D0
1070 DATA &H00DA, &H00E2, &H00EA, &H00F0, &H00F5, &H00FA, &H00FD, &H00FE
1080 DATA &H00FF, &H00FE, &H00FD, &H00FA, &H00F5, &H00F0, &H00EA, &H00E2
1090 DATA &H00DA, &H00D0, &H00C6, &H00BC, &H00B0, &H00A5, &H0098, &H008C
1100 DATA &H0080, &H0073, &H0067, &H005A, &H004F, &H0043, &H0039, &H002F
1110 DATA &H0025, &H001D, &H0015, &H000F, &H000A, &H0005, &H0002, &H0001
1120 DATA &H0000, &H0001, &H0002, &H0005, &H000A, &H000F, &H0015, &H001D
1130 DATA &H0025, &H002F, &H0039, &H0043, &H004F, &H005A, &H0067, &H0073
