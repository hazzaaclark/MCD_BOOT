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

    include     "BIOS_inc.asm"
    include     "macros.asm"

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

SUB_JUMP_TABLE:         
    DC.W        SP_INIT-SUB_JUMP_TABLE
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

;--------------------------------------------------------
;           INITIALISE THE BACKEND FOR WHICH
;           THE ISO STANDARD IS PRODUCED BY 
;      DEFINING THE REGISTERS USED TO PARSE CONTENTS
;--------------------------------------------------------

INIT_ISO9660:                   

    PUSH            D0-D7/A0-A6                 ;; STORE ALL RELEVANT REGISTERS FOR CACHE
    MOVE.L          #$10, D0                    ;; START OFFSET FOR PARSING DISC
    MOVE.L          #$2, D1                     ;; OFFSET SIZE  
    LEA.L           SP_SECTOR, A0               ;; EVALUATE THE START OFFSET AT THE EFFECTIVE ADDRESS
    BSR             READ_CD                     ;; BRANCH OFF TO READ THE CONTENTS OF THE CD, BASED ON THE ABOVE PRE-REQ'S


READ_CD:

    PUSH            D0-D7/A0-A6                 ;; STORE ALL RELEVANT REGISTERS FOR CACHE
    LEA             BIOS_INIT_STDCALL(PC), A5   ;; INIT AND LOAD THE STDCALL BIOS PARAM (STORES A 32 BIT STATIC LONG)
    MOVE.L          DO,(A5)                     ;; WRITE START OFFSET TO BIOS STDCALL
    MOVE.L          D1,4(A5)                    ;; WRITE START OFFSET SIZE TO BIOS STDCALL
    MOVE.L          A0,8(A5)                    ;; WRITE RESULT TO THE RELEVANT ADDRESS
    MOVE.L          A5, A0                      ;; STORE RESULT
    BIOS_CDC_STOP
    BIOS_ROM_READ_SECTOR

@waitSTAT:

    BIOS_CDC_START
    BCS @waitSTAT

@waitREAD:

    BIOS_CDC_READ
    BCC @waitREAD

@waitTRANSFER:
    MOVEA.L         8(A5), A0                   ;; GET THE DESITNAION ADDRESS IN RELATION TO THE BITMASK
    LEA             12(A5), A1                  ;; GET HEADER STORE
    BIOS_CDC_WRITE                              ;; WRITE CONTENTS
    BRA             @waitTRANSFER               ;; IF NO CONTENTS, BRANCH BACK AND RUN THE SUBROUTINE AGAIN
    BIOS_CDC_CALLBACK
    ADDQ.L          #1, (A5)                    ;; INCREMENT WRITE SECTOR=
    ADDI.L          #$0800, 8(A5)               ;; INCREMENT DEST REGISTER
    SUBQ.L          #1, 4(A5)
    BNE             @waitSTAT
    PUSH            D0-D7/A0-A6
    RTS

BIOS_INIT_STDCALL:

    DC.L            0, 0, 0, 0

HEADER:

    DS.L            32
