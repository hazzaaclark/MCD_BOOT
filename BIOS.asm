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
SP_ROOT_DIR_BUF     EQU         156

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
;       THIS WORKS UNDER THE GUISE OF BEING CALLED
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

    MOVEM.L         D0-D7/A0-A6,-(SP)           ;; STORE ALL RELEVANT REGISTERS FOR CACHE
    MOVE.L          #$10, D0                    ;; START OFFSET FOR PARSING DISC
    MOVE.L          #$2, D1                     ;; OFFSET SIZE  
    LEA.L           SP_SECTOR, A0               ;; EVALUATE THE START OFFSET AT THE EFFECTIVE ADDRESS
    BSR             READ_CD                     ;; BRANCH OFF TO READ THE CONTENTS OF THE CD, BASED ON THE ABOVE PRE-REQ'S

    LEA.L           SP_SECTOR, A0               ;; AFTER WHICH, GET THE POINTER OFFSET CURRENTLY AT A0
    LEA.L           SP_ROOT_DIR_BUF(A0), A1     ;; STORE THE ROOT DIRECTORY RECORD FROM A0 AND LOAD IT INTO A1

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
    MOVE.B          9(A1), D0                   ;; Address register corrected to A1

    MOVE.L          #$20, D1                    ;; SIZE OF SECTOR OFFSET
    BSR             READ_CD

    MOVEM.L         (SP)+, D0-D7/A0-A6          ;; RESTORE REGISTERS
    RTS

READ_CD:

    MOVEM.L         D0-D7/A0-A6,-(SP)           ;; STORE ALL RELEVANT REGISTERS FOR CACHE
    LEA             BIOS_INIT_STDCALL(PC), A5   ;; INIT AND LOAD THE STDCALL BIOS PARAM (STORES A 32 BIT STATIC LONG)
    MOVE.L          D0, (A5)                    ;; WRITE START OFFSET TO BIOS STDCALL
    MOVE.L          D1, 4(A5)                   ;; WRITE START OFFSET SIZE TO BIOS STDCALL
    MOVE.L          A0, 8(A5)                   ;; WRITE RESULT TO THE RELEVANT ADDRESS
    MOVE.L          A5, A0                      ;; STORE RESULT
    BIOS_CDC_STOP
    BIOS_ROM_READ_SECTOR

    MOVEM.L         (SP)+, D0-D7/A0-A6          ;; RESTORE REGISTERS
    RTS

FIND_FILE:
    MOVEM.L         A1/A2/A6, -(SP)             ;; STORE USED REGISTERS FOR READING CD FILE
    LEA.L           SP_SECTOR, A1               ;; LOAD THE SECTOR OFFSET INTO A1

@readFILENAME_START:
    MOVEA.L         A0, A6                      ;; STORE FILENAME POINTER
    MOVE.B          (A6)+, D0                   ;; ADD THE CORRESPONDENCE FROM A6 INTO D0 (READ CHAR FROM FILE)

@findFIRST_CHAR:
    MOVEA.L         A1, A2                      ;; STORE SECTOR BUFFER POINTER BEFORE COMPARISON
    CMP.B           (A1)+, D0                   ;; COMPARE THE RESPECTIVE CHAR DIRECTIVE
    BNE.B           @findFIRST_CHAR

@waitSTAT:

    BIOS_CDC_START
    BCS             @waitSTAT

@waitREAD:

    BIOS_CDC_READ
    BCC             @waitREAD

@waitTRANSFER:
    MOVEA.L         8(A5), A0                   ;; GET THE DESTINATION ADDRESS IN RELATION TO THE BITMASK
    LEA             12(A5), A1                  ;; GET HEADER STORE
    BIOS_CDC_WRITE                              ;; WRITE CONTENTS
    BRA             @waitTRANSFER               ;; IF NO CONTENTS, BRANCH BACK AND RUN THE SUBROUTINE AGAIN
    BIOS_CDC_CALLBACK
    ADDQ.L          #1, (A5)                    ;; INCREMENT WRITE SECTOR
    ADDI.L          #$0800, 8(A5)               ;; INCREMENT DEST REGISTER
    SUBQ.L          #1, 4(A5)
    BNE             @waitSTAT
    MOVEM.L         (SP)+, D0-D7/A0-A6          ;; RESTORE REGISTERS
    RTS

BIOS_INIT_STDCALL:

    DC.L            0, 0, 0, 0

HEADER:

    DS.L            32

SP_BITSHIFT:
    
    DC.L            8
