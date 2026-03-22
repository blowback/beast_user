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
110 REM CALL S%(BM%, C%) passes HL=&bitmask, DE=&column
120 REM The stub dereferences the pointers:
130 REM   EX DE,HL / LD A,(HL) / EX DE,HL  ; A = column
140 REM   LD E,(HL) / INC HL / LD D,(HL)   ; DE = bitmask
150 REM   EX DE,HL / CALL &HFDD6 / RET     ; HL = bitmask
160 REM
170 S% = 60000
180 FOR I% = 0 TO 10: READ V%: POKE S%+I%, V%: NEXT I%
210 REM
220 REM --- Write all segments ON to columns 20-23 ---
230 BM% = &H3FFF: REM all 14 segments ON
240 FOR C% = 20 TO 23
250   CALL S%(BM%, C%)
260 NEXT C%
360 REM
370 PRINT "All segments ON for columns 20-23"
380 END
390 REM
400 REM --- MBB_WRITE_LED stub (11 bytes) ---
410 DATA &HEB, &H7E, &HEB, &H5E, &H23, &H56, &HEB, &HCD, &HD6, &HFD, &HC9
