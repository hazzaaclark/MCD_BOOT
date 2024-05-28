;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------
;--------------------------------------------------------
;          THIS FILE PERTAINS TOWARDS THE BIOS
;       FUNCTIONALITY - DECLARING AND ACCESSING
;     THIS SUB-ROUTINES FOR THE CPU TO BOOT THE DISC
;--------------------------------------------------------

INCLUDE     "BIOS_inc.asm"
INCLUDE     "macros.asm"

;--------------------------------------------------------
;       DETERMINE THE VALUES NECESSARY FOR ACCESSING
;               SPECIFICS IN THE HARDWARE
;--------------------------------------------------------

INIT_SYS            EQU         0
MD_VER              EQU         0
SP_SECTOR           DC.L        0

ORG                 EQU         $6000

SUB_HEADER:

NODULE_NAME:            DC.B        'MAIN-SUBCPU', 0
MODULE_VERSION:         DC.W        0,0
MODULE_NEXT:            DC.L        0
MODULE_SIZE:            DC.L        0
MODULE_START_ADDR:      DC.L        $20
MODULE_WORK_ADDR:       DC.L        0

SUB_JUMP_TABLE:         DC.W        SP_INIT-SUB_JUMP_TABLE
                        DC.W        SP_INIT_DRIVE-SUB_JUMP_TABLE
                        DC.W        SP_IRQ-SUB_JUMP_TABLE

;--------------------------------------------------------
;              INITIALISE THE STACK POINTER
;       THIS WORKS UNDEER THE GUISE OF BEING CALLED
;       ON A SINGLE COUROUTINE AFTER THE INITIAL BOOT
;--------------------------------------------------------

SP_INIT:

BIOS_MUSIC_STOP
ANDI.B          #$FA, SUB_MEM               ;; SET SUB CPU MEMORY TO 2M
BSR             INIT_ISO9660                ;; AFTER WHICH, BRANCH OFF TO INITIALISE THE CD
CLR.B           SUB_SECOND_FLAG             ;; CLEAR THE STATUS FLAG TO INITIAL DRIVE   
MOVEQ           #0, D0                      ;; THIS IS THE MCD HALTING FOR A BRIEF MOMENT BEFORE LOADING THE 'SEGA' SPLASH
RTS

INIT_ISO9660:                   

PUSH            D0-D7/A0-A6                 ;; STORE ALL RELEVANT REGISTERS FOR CACHE
MOVE.L          #$10, D0                    ;; START OFFSET FOR PARSING DISC
MOVE.L          #$2, D1                     ;; OFFSET SIZE  
LEA.L           SP_SECTOR, A0               ;; EVALUATE THE START OFFSET AT THE EFFECTIVE ADDRESS
BSR             READ_CD                     ;; BRANCH OFF TO READ THE CONTENTS OF THE CD, BASED ON THE ABOVE PRE-REQ'S

READ_CD:
