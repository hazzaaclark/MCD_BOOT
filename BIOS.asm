;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------
;          THIS FILE PERTAINS TO THE BIOS
;       FUNCTIONALITY - DECLARING AND ACCESSING
;     THIS SUB-ROUTINES FOR THE CPU TO BOOT THE DISC
;--------------------------------------------------------

    INCLUDE     "BIOS_inc.asm"
    INCLUDE     "macros.asm"

;--------------------------------------------------------
;       DETERMINE THE VALUES NECESSARY FOR ACCESSING
;               SPECIFICS IN THE HARDWARE
;--------------------------------------------------------

SP_SECTOR:          DC.L        0

MODULE_NAME:            DC.B        'MAIN-SUBCPU',0
MODULE_VERSION:         DC.W        0, 0
MODULE_NEXT:            DC.L        0
MODULE_SIZE:            DC.L        0
MODULE_START_ADDR:      DC.L        $20
MODULE_WORK_ADDR:       DC.L        0

SUB_JUMP_TABLE:         DC.W        SP_INIT-SUB_JUMP_TABLE
                        DC.W        SP_MAIN-SUB_JUMP_TABLE
                        DC.W        SP_IRQ-SUB_JUMP_TABLE
                        DC.W        0

;--------------------------------------------------------
;              INITIALISE THE STACK POINTER
;       THIS WORKS UNDER THE GUISE OF BEING CALLED
;       ON A SINGLE COUROUTINE AFTER THE INITIAL BOOT
;--------------------------------------------------------

SP_INIT:
    ANDI.B          #$FA, $FF8003               ;; SET SUB CPU MEMORY TO 2M
    BSR             INIT_ISO9660                ;; AFTER WHICH, BRANCH OFF TO INITIALISE THE CD
    CLR.B           $FF800F                     ;; CLEAR THE STATUS FLAG TO INITIAL DRIVE   
    MOVEQ           #0, D0
    RTS

;------------------------------------------
;       EMPTY FUNCTION THAT DOES NOTHING
;------------------------------------------

SP_IRQ:
    RTS

;------------------------------------------
;  MAIN ROUTINE FOR INITIALISING THE DRIVE
;------------------------------------------

SP_MAIN:
    TST.B   $FF800E
    BNE     SP_MAIN
    MOVE.B  #1, $FF800F

@LOOP:
    TST.B   $FF800E
    BEQ     @LOOP

    MOVEQ   #0, D1
    MOVE.B  $FF800E, D1
    BTST    #7, D1
    ANDI.B  #$7F, D1    
    ADD.W   D1, D1
    ADD.W   D1, D1
    JSR     OPERAND_TABLE
    MOVEQ   #0, D0
    MOVE.B  $FF800E, D0  
    ADD.W   D0, D0
    ADD.W   D0, D0
    MOVE.L  OPERAND(PC), A0
    MOVE.L  (A0, D0.W), A0
    JSR     (A0)
    MOVE.B  #0, $FF800F
    BRA     SP_MAIN

;--------------------------------------------------------
;           INITIALISE THE BACKEND FOR WHICH
;           THE ISO STANDARD IS PRODUCED BY 
;      DEFINING THE REGISTERS USED TO PARSE CONTENTS
;--------------------------------------------------------

INIT_ISO9660:                   
    PUSH            D0-D7/A0-A6           ;; STORE ALL RELEVANT REGISTERS FOR CACHE
    MOVE.L          #$10, D0                    ;; START OFFSET FOR PARSING DISC
    MOVE.L          #$2, D1                     ;; OFFSET SIZE  
    LEA.L           SP_SECTOR, A0               ;; EVALUATE THE START OFFSET AT THE EFFECTIVE ADDRESS
    BSR             READ_CD                     ;; BRANCH OFF TO READ THE CONTENTS OF THE CD, BASED ON THE ABOVE PRE-REQ'S
    LEA.L           SP_SECTOR, A0               ;; AFTER WHICH, GET THE POINTER OFFSET CURRENTLY AT A0
    LEA.L           156(A0), A1                 ;; STORE THE ROOT DIRECTORY RECORD FROM A0 AND LOAD IT INTO A1

    ;; THE FOLLOWING BITSHIFT SECTION SERVES TO
    ;; PROVIDE LIAISSE FOR THE CD DRIVE 
    ;; -----------------------------------------
    ;; SUCH THAT IT IS ABLE TO STORE THE CURRENT OFFSET
    ;; OF THE READER CONCURRENTLY BASED ON WHICH NIBBLE IS REQUIRED (6-9)

    MOVE.B          6(A1), D0                   ;; GET THE FIRST PART OF THE SECTOR OFFSET
    LSL.L           #8, D0                      ;; SHIFT LEFT LOGICAL BY 8 BITS
    MOVE.B          7(A1), D0
    LSL.L           #8, D0
    MOVE.B          8(A1), D0
    LSL.L           #8, D0
    MOVE.B          9(A1), D0
    MOVE.L          #$20, D1                    ;; SIZE OF SECTOR OFFSET
    BSR             READ_CD
    POP             D0-D7/A0-A6          ;; RESTORE REGISTERS
    RTS

READ_CD:
    PUSH            D0-D7/A0-A6                 ;; STORE ALL RELEVANT REGISTERS FOR CACHE
    LEA             BIOS_INIT_STDCALL(PC), A5   ;; INIT AND LOAD THE STDCALL BIOS PARAM (STORES A 32 BIT STATIC LONG)
    MOVE.L          D0, (A5)                    ;; WRITE START OFFSET TO BIOS STDCALL
    MOVE.L          D1, 4(A5)                   ;; WRITE START OFFSET SIZE TO BIOS STDCALL
    MOVE.L          A0, 8(A5)                   ;; WRITE RESULT TO THE RELEVANT ADDRESS
    MOVEA.L         A5, A0                      ;; STORE RESULT
    BIOS_CDC_STOP
    BIOS_ROM_READ_SECTOR

FIND_FILE:
    PUSH              A1/A2/A6             ;; STORE USED REGISTERS FOR READING CD FILE
    LEA.L             SP_SECTOR, A1               ;; LOAD THE SECTOR OFFSET INTO A1


BIOS_INIT_STDCALL:
    DC.L            0, 0, 0, 0, 0
HEADER:
    DS.L            32
;--------------------------------------------------------
;    THE FOLLOWING PERTAINS TO THE ENCOMPASSING
;   LOGIC SURROUNDING THE OPERANDS USED FOR RELEVANT
;                   CD OPERATIONS
;--------------------------------------------------------

OPERAND_TABLE:

OPERAND:
    BRA.W           OP_NULL
    BRA.W           OP_GET_WORD_RAM
    BRA.W           OP_LOAD_FILE_NAME
    
OP_GET_WORD_RAM:
    BSET            #0, $FF8003                       
    RTS

OP_LOAD_FILE_NAME:
    LEA             @BOOT(PC),A0
    BSR             FIND_FILE
    MOVE.L          #$80000, A0
    BSR             READ_CD
    RTS

@BOOT:
    INCBIN      "SEGA.bin"
    ALIGN       2

OP_NULL:
    RTS
