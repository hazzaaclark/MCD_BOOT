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

    ;INCBIN  "security\jap.bin"
    INCBIN  "security\usa.bin"
    ;INCBIN "security\eur.bin"

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

    JMP         $200000             ;; JUMP TO STACK START OFFSET

;---------------------------------------
;       INITIALISE THE SUBROUTINE 
;
;   THIS WORKS ON THE BASIS OF BEING
;  ABLE TO TEST IF THE VALID 'SEGA' SPLASH
;   ADDRESS IS PRESENT, IF SO, HALT THE SYSTEM
;           AS IT PREPARES TO BOOT
;---------------------------------------


INIT_SUB:
    TST.B       $A1200F             
    BNE         INIT_SUB
    MOVE.B      #00, $A1200E

;---------------------------------------
;       NOW WE WAIT AND TEST TO SEE
;   IF THE RELEVANT SECURITY FILE WORKS
;   IN TANDEM WITH THE VERSION BIOS
;---------------------------------------

@WAITRESP:
    TST.B       $A1200F
    BEQ         @WAITRESP
    MOVE.B      D0, $A1200E

@WAITRESP_2:
    TST.B       $A1200F
    BEQ         @WAITRESP_2

ASYNC_SUB: 
    TST.B       $A1200F
    BNE         ASYNC_SUB
    MOVE.B      #00, $A1200E

;---------------------------------------
;   FINALLY, BOOT INTO THE RELEVANT 
;   'SEGA' SPLASH ADDRESS AND SET THE 
;    BRANCH OF THE SUBROUTINE 
;       EQUAL TO THE RETURN TYPE
;---------------------------------------

@WAITREADY:
    TST.B       $A1200F
    BEQ         @WAITREADY
    MOVE.B      D0, $A1200E
    RTS


