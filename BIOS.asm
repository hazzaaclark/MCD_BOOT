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

    ORG         $6000

;--------------------------------------------------------
;       DETERMINE THE VALUES NECESSARY FOR ACCESSING
;               SPECIFICS IN THE HARDWARE
;--------------------------------------------------------

INIT_SYS            EQU         0
MD_VER              EQU         0
SP_SECTOR:          DC.L        0


MODULE_NAME:            DC.B        'MAIN-SUBCPU',0
MODULE_VERSION:         DC.W        0, 0
MODULE_NEXT:            DC.L        0
MODULE_SIZE:            DC.L        0
MODULE_START_ADDR:      DC.L        $20
MODULE_WORK_ADDR:       DC.L        0
SUB_JUMP_TABLE:         
                        DC.W        SP_INIT-SUB_JUMP_TABLE
                        DC.W        SP_INIT_DRIVE-SUB_JUMP_TABLE
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

SP_INIT_DRIVE:
    MOVEQ           #0, D0
    LEA             DRIVE_INIT_PARAMS(PC), A0
    BIOS_DRV_INIT   
    BIOS_CDC_STOP
    BIOS_CDC_STATUS


DRIVE_INIT_PARAMS:
    DC.B            1, $FF
    EVEN

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

    LEA.L             SP_SECTOR, A0               ;; AFTER WHICH, GET THE POINTER OFFSET CURRENTLY AT A0
    LEA.L             156(A0), A1     ;; STORE THE ROOT DIRECTORY RECORD FROM A0 AND LOAD IT INTO A1

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
    MOVEA.L          A5, A0                      ;; STORE RESULT
    BIOS_CDC_STOP
    BIOS_ROM_READ_SECTOR

FIND_FILE:
    PUSH              A1/A2/A6             ;; STORE USED REGISTERS FOR READING CD FILE
    LEA.L             SP_SECTOR, A1               ;; LOAD THE SECTOR OFFSET INTO A1

@readFILENAME_START:
    MOVEA.L         A0, A6                      ;; STORE FILENAME POINTER
    MOVE.B          (A6)+,D0                   ;; ADD THE CORRESPONDENCE FROM A6 INTO D0 (READ CHAR FROM FILE)

@findFIRST_CHAR:
    MOVEA.L         A1,A2                      ;; STORE SECTOR BUFFER POINTER BEFORE COMPARISON
    CMP.B           (A1)+,D0                   ;; COMPARE THE RESPECTIVE CHAR DIRECTIVE
    BNE.B           @findFIRST_CHAR

@checkCHARS:
    MOVE.B          (A6)+,D0                    ;; INCREMENT INFO BYTES CACHE BY THE CONTENTS LOADED FROM D0
    BEQ             @GETINFO                    ;; IF SUCCESSFUL, BRANCH TO THE LOOP EQUAL TO IT'S RETURN TYPE  
    CMP.B           (A1)+,D0    
    BNE.B           @readFILENAME_START
    BRA.B           @checkCHARS

@GETINFO:
    SUB.L           #33, A2
    MOVE.B          6(A2), D0
    LSL.L           #8, D0
    MOVE.B          7(A2), D0
    LSL.L           #8, D0
    MOVE.B          8(A2), D0
    LSL.L           #8, D0
    MOVE.B          9(A2), D0

    MOVE.B	14(A2),D1	
	LSL.L	#8,D1
    MOVE.B	15(A2),D1
    LSL.L	#8,D1
	MOVE.B	16(A2),D1
	LSL.L	#8,D1
	MOVE.B	17(A2),D1
						
	LSR.L	#8,D1
	LSR.L	#3,D1
	
    POP	    A1/A2/A6		
	RTS


@waitSTAT:

    BIOS_CDC_START
    BCS             @waitSTAT

@waitREAD:

    BIOS_CDC_READ
    BCC             @waitREAD

@WaitTRANSFER:
    MOVEA.L         8(A5), A0                   ;; GET THE DESTINATION ADDRESS IN RELATION TO THE BITMASK
    LEA             12(A5), A1                  ;; GET HEADER STORE
    BIOS_CDC_WRITE                              ;; WRITE CONTENTS
    BCC             @waitTRANSFER               ;; IF NO CONTENTS, BRANCH BACK AND RUN THE SUBROUTINE AGAIN
    BIOS_CDC_CALLBACK
    ADDQ.L          #1, (A5)                    ;; INCREMENT WRITE SECTOR
    ADDI.L          #$0800, 8(A5)               ;; INCREMENT DEST REGISTER
    SUBQ.L          #1, 4(A5)
    BNE             @waitSTAT
    POP             D0-D7/A0-A6          ;; RESTORE REGISTERS
    RTS

BIOS_INIT_STDCALL:

    DC.L            0, 0, 0, 0, 0

HEADER:

    DS.L            32
;--------------------------------------------------------
;    THE FOLLOWING PERTAINS TOWARDS THE ENCOMPASSING
;   LOGIC SURROUNDING THE OPERANDS USED FOR RELEVANT
;                   CD OPERATIONS
;--------------------------------------------------------

OPERAND_TABLE:

    BRA.W           OP_NULL
    BRA.W           OP_GET_WORD_RAM
    BRA.W           OP_LOAD_FILE_NAME

OP_GET_WORD_RAM:
    BSET            #0, $FF8003                       
    RTS

OP_LOAD_FILE_NAME:
    LEA             @BOOT(PC), A0
    BSR             FIND_FILE
    MOVE.L          #$80000, A0
    BSR             READ_CD
    RTS

@BOOT:
    DC.B        'game.bin', 0
    ALIGN       2

OP_NULL:
    RTS
