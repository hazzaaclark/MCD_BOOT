;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;     THIS FILE PERTAINS TOWARDS THE SECURITY FEATURES
;       SUCH AS GENERIC TMSS AND OTHER CHECKERS
;--------------------------------------------------------

    INCLUDE "BIOS_inc.asm"
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

    INCBIN  "security\jap.bin"
    ;incbin "security\eur.bin"

    BRA     INIT_PROG
    ALIGN   $600            ;; MATCHES THE REGION AFTER COMPILE TIME

INIT_PROG:

    BSET        #1, $A12003         ;; GIVE WORD TO SUB CPU

@INITLOOP:

    TST.B       $A1200F             ;; OFFSET TO DETERMINE IF THE SUB CPU HAS FINISHED INIT
    BNE         @INITLOOP

    MOVE.B      #01, D0             ;; SET COMMAND TO LOAD THE CORRESPONDING FILE
    BSR         INIT_SUB            ;; EXECUTE SUB ROUTINE FOR INIT

    MOVE.B      #02, D0             ;; REQUEST WORDWISE RAM FROM THE FILE
    BSR         INIT_SUB

    JMP         $200000             ;; JUMP TO STACK START OFFSER

INIT_SUB:
    TST.B       $A1200F             
    BNE         INIT_SUB
    MOVE.B      #00, $A1200E

@WAITRESP:
    TST.B       $A1200F
    BEQ         @WAITRESP
    MOVE.B      D0, $A1200E

@WAITRESP_2:
    TST.B       $A1200F
    BNE         @WAITRESP_2

ASYNC_SUB: 
    TST.B       $A1200F
    BNE         ASYNC_SUB
    MOVE.B      #00, $A1200E

@WAITREADY:
    TST.B       $A1200F
    BEQ         @WAITREADY
    MOVE.B      D0, $A1200E
    RTS


