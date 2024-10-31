;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;     THIS FILE PERTAINS TOWARDS THE SECURITY FEATURES
;       SUCH AS GENERIC TMSS AND OTHER CHECKERS
;--------------------------------------------------------

    INCLUDE "macros.asm"    

;--------------------------------------------------------
;       DEFINE THE CONSTANTS NECESSARY FOR DETERMINING
;               THE CORRECT BIOS BOOT REGION
;--------------------------------------------------------
;       THIS WORKS UNDER THE GUISE OF ASSUMING THAT
;   ALL CODE EXECUTES FROM THE SECURITY SECTOR BEFOREHAND
;   BEFORE BOOTING INTO THE DESIGNATED REGION
;--------------------------------------------------------

SECURITY_SEC:

    ;INCBIN  "security/jap.bin"
    ;INCBIN  "security/usa.bin"
    INCBIN "security/eur.bin"

     BRA     INIT_PROG
     ALIGN   $600  ;; MATCHES THE REGION AFTER COMPILE TIME

INIT_PROG:
                MOVE.L      #$C0000000, $C00004
                MOVE.L      #64, D0

SET_PAL_LOOP:
                MOVE.W      #$0F00, $C00000
                DBF         D0, SET_PAL_LOOP   

INITLOOP:
                BRA INITLOOP
