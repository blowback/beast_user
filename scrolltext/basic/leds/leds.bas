10 REM === MicroBeast LED Demo - Step 1: Raw Segment Control ===
20 REM Turn ON all 14 segments of the last 4 LED positions (columns 20-23)
30 REM
40 REM MBB_WRITE_LED (&HFDD6): HL = bitmask, A = column (0-23)
50 REM Bitmask &H3FFF = all 14 segments ON
60 REM
70 REM MBASIC cannot set CPU registers directly, so we POKE a small
80 REM machine-code stub into memory that loads HL and A then calls BIOS.
90 REM
100 REM --- Machine code stub at address 60000 (&HEA60) ---
110 REM The stub does:
120 REM   LD HL,(60010)   ; load bitmask from parameter area (&HEA6A)
130 REM   LD A,(60012)    ; load column number (&HEA6C)
140 REM   CALL &HFDD6     ; MBB_WRITE_LED
150 REM   RET             ; return to BASIC
160 REM
170 S = 60000
180 REM LD HL,(&HEA6A) = 2Ah 6Ah EAh
190 POKE S+0, &H2A: POKE S+1, &H6A: POKE S+2, &HEA
200 REM LD A,(&HEA6C) = 3Ah 6Ch EAh
210 POKE S+3, &H3A: POKE S+4, &H6C: POKE S+5, &HEA
220 REM CALL &HFDD6 = CDh D6h FDh
230 POKE S+6, &HCD: POKE S+7, &HD6: POKE S+8, &HFD
240 REM RET = C9h
250 POKE S+9, &HC9
260 REM
270 REM --- Write all segments ON to columns 20-23 ---
280 REM Set bitmask = &H3FFF (all segments on)
290 POKE 60010, &HFF: REM low byte of HL (L = outer segments)
300 POKE 60011, &H3F: REM high byte of HL (H = inner segments)
310 REM
320 FOR C = 20 TO 23
330   POKE 60012, C: REM column number into A parameter
340   CALL S
350 NEXT C
360 REM
370 PRINT "All segments ON for columns 20-23"
380 END
