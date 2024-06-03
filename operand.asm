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