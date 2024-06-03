;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;     THIS FILE PERTAINS TOWARDS THE SECURITY FEATURES
;       SUCH AS GENERIC TMSS AND OTHER CHECKERS
;--------------------------------------------------------

    INCLUDE "BIOS.asm"
    INCLUDE "BIOS_inc.asm"
    INCLUDE "macros.asm"

TMSS:

    MOVE.B      ($A10001), D0
    AND.B       #$0F, D0
    MOVE.L      #'SEGA', ($A1000)
