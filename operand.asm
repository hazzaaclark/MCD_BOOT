;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;      THIS FILE PERTAINS TOWARDS THE ENCOMPASSING
;   LOGIC SURROUNDING THE OPERANDS USED FOR RELEVANT
;                   CD OPERATIONS
;--------------------------------------------------------

    INCLUDE "macros.asm"
    INCLUDE "BIOS_inc.asm"
    INCLUDE "BIOS.asm"


OPERAND_TABLE:

        BRA.W           OP_NULL
        BRA.W           OP_GET_WORD_RAM
        BRA.W           OP_LOAD_FILE_ID
        BRA.W           OP_LOAD_FILE_NAME
        BRA.W           OP_PLAY_CDDA_REP
        BRA.W           OP_PLAY_CDDA
        BRA.W           OP_PAUSE_CDDA
        BRA.W           OP_UNPAUSE_CDDA
        BRA.W           OP_STOP_CDDA
        BRA.W           OP_CDDA_FO
        BRA.W           OP_CDDA_SEEK 

OP_GET_WORD_RAM:
    BSET            #SUB_MEM
    RTS

OP_LOAD_FILE_ID:
    MOVEQ           #0, D1
    MOVE.W          SUB_COMMON_0, D1        ;; GET COMMON FILE ID HEADER INFO
    LSL.L           #1, D1
    MOVE.W          (PC, D1.W), D1          ;; SET THE CURRENT INDEX OF THE FILE ID IN THE PC AND MOVE TO D1
    LEA             (PC, D1.W), A0          ;; LOAD PREVIOUS INTO A0
    BSR             FIND_FILE               ;; BRANCH TO FIND FILE SUBROUTINE
