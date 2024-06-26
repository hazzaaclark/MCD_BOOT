;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;     THIS FILE PERTAINS TOWARDS THE DECLARATION
;    OF MACROS IN RELATION TO THE BIOS DIRECTIVES
;--------------------------------------------------------

;--------------------------------------------------------
    INCLUDE "BIOS_inc.asm"
;--------------------------------------------------------

ALIGN MACRO
        CNOP 0,\1
        ENDM

POP MACRO CODE
	MOVEM.L	(A7)+,\CODE
    ENDM

;; 28/05/24 - I WAS SILLY AND THOUGHT PUSH WAS A 68K KEYWORD
;; SO HERE IS A BASELINE MACRO TO FILL THAT FUNCTIONALITY

;-----------------------------------------------------------

;; THE REASON FOR CREATING A PUSH MACRO TO BEGIN WITH IS MUCH LIKE
;; THE X86 REPRESENTATIVE, PUSH ALLOWS FOR IMMEDIATE ADDRESSING
;; IT TAKES ONE OPERAND, TYPICALLY A SET OF REGISTERS AND STORES THEM
;; AS 32 BIT ADDRESSABLE CONTENTS

;-----------------------------------------------------------

;; MUCH LIKE X86, THIS WILL BECOME ALL THE MORE IMPORTANT WHEN
;; STORING RELEVANT CONTENTS WITHIN REGISTERS BEFORE BRANCHING
;; OFF TO A SUBROUTINE

PUSH MACRO CODE
    MOVEM.L \CODE, -(A7)
    ENDM

;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO THE
;              SUB-ROUTINE OF THE CDDA AND
;             SUBSEQUENT BIOS FUNCTIONALITY
;--------------------------------------------------------

;; INITALISE THE BIOS BASED ON THE DIRECTIVE VALUE
;; MOVE ALL CORRESPONDING BOOT INFORMATION INTO D0
;; AND JUMP SUB ROUTINE TO BIOS BOOT 

CD_BIOS MACRO CD_BIOS_INIT
        MOVEQ   #0, D0
        MOVE.W  \CD_BIOS_INIT,D0
        JSR     _CDBIOS
        ENDM

;; CALL THE BACKUP RAM IN CASE OF ADDITIONAL MEANS 
;; FOR READING AND PARSING DISC CONTENTS

BURAM MACRO CD_BIOS_INIT
        MOVE.W  \CD_BIOS_INIT, D0
        JSR     _BURAM
        ENDM   

;; READ THE STACK TRACE FROM OFFSET $01 TO CLOSE THE DISK TRAY
;; FROM THERE, IT WILL DETERMINE IF REG 7 HAS BEEN SET TO READ THE FIRST
;; TRACK OF THE ISO/CUE

BIOS_DRV_INIT MACRO
        CD_BIOS #DRVINIT
        ENDM

;; ADVERSLY, DETERMINE WHEN THE DISK DRIVE IS OPEN

BIOS_DRV_OPEN MACRO
        CD_BIOS #DRVOPEN
        ENDM

;; MUSIC MACROS - ENABLES THE CDDA SUPPORT

BIOS_MUSIC_STOP MACRO
        CD_BIOS #MSCSTOP
        ENDM

BIOS_MUSIC_PLAY MACRO
        CD_BIOS #MSCPLAY
        ENDM

BIOS_MUSIC_PLAY1 MACRO
        CD_BIOS #MSCPLAY1
        ENDM

BIOS_MUSIC_PLAYER MACRO
        CD_BIOS #MSCPLAYR
        ENDM

BIOS_MUSIC_PLAYER_TIME MACRO
    CD_BIOS #MSCPLAYT
    ENDM

BIOS_MUSIC_SEEK MACRO
    CD_BIOS #MSCSEEK
    ENDM

BIOS_MUSIC_SEEK_ONCE MACRO
    CD_BIOS #MSCSEEK1
    ENDM

BIOS_MUSIC_SEEK_TIMER MACRO
    CD_BIOS #MSCSEEKT
    ENDM

BIOS_MUSIC_PAUSE_ON MACRO
    CD_BIOS #MSCPAUSEON
    ENDM

BIOS_MUSIC_PAUSE_OFF MACRO
    CD_BIOS #MSCPAUSEOFF
    ENDM

BIOS_MUSIC_SCANFF MACRO
    CD_BIOS #MSCSCANFF
    ENDM

BIOS_MUSIC_SCANBW MACRO
    CD_BIOS #MSCSCANFR
    ENDM

BIOS_MUSIC_SCAN_OFF MACRO
    CD_BIOS #MSCSCANOFF
    ENDM

;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO THE
;               SUB-ROUTINE OF THE CD-ROM
;--------------------------------------------------------

BIOS_ROM_READ MACRO
    CD_BIOS #ROMREAD
    ENDM

BIOS_ROM_READ_SECTOR MACRO
    CD_BIOS #ROMREADN
    ENDM

BIOS_ROM_READ_ENDIAN MACRO
    CD_BIOS #ROMREADE
    ENDM

BIOS_ROM_SEEK MACRO
    CD_BIOS #ROMSEEK
    ENDM

BIOS_ROM_PAUSE_ON MACRO
    CD_BIOS #ROMPAUSEON
    ENDM

BIOS_ROM_PAUSE_OFF MACRO
    CD_BIOS #ROMPAUSEOFF
    ENDM

;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO
;       GENERAL PURPOSE BIOS FUNCTIONS AND CHECKS
;--------------------------------------------------------

BIOS_SEEK_QUERY MACRO
    CD_BIOS #CDBCHK
    ENDM

BIOS_STATUS_TABLE MACRO
    CD_BIOS #CDBSTAT
    ENDM

BIOS_TRACK_READ MACRO
    CD_BIOS #CDBTOCREAD
    ENDM

BIOS_TRACK_WRITE MACRO
    CD_BIOS #CDBTOCWRITE
    ENDM

BIOS_TRACK_PAUSE MACRO
    CD_BIOS #CDBPAUSE
    ENDM

BIOS_SET_VOLUME MACRO
    CD_BIOS #FDRSET
    ENDM

BIOS_RAMP_VOLUME MACRO
    CD_BIOS #FDRCHG
    ENDM

;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO
;                 THE BIOS' CDC BUFFER
;--------------------------------------------------------

BIOS_CDC_START MACRO
    CD_BIOS #CDCSTART
    ENDM

BIOS_CDC_STOP MACRO
    CD_BIOS #CDCSTOP
    ENDM

BIOS_CDC_STATUS MACRO
    CD_BIOS #CDCSTAT
    ENDM

BIOS_CDC_READ MACRO
    CD_BIOS #CDCREAD
    ENDM

BIOS_CDC_WRITE MACRO
    CD_BIOS #CDCTRN
    ENDM

BIOS_CDC_CALLBACK MACRO
    CD_BIOS #CDCACK
    ENDM

BIOS_CDC_MODE_SET MACRO
    CD_BIOS #CDCSETMODE
    ENDM

;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO THE
;               SUB-ROUTINE OF THE SUB CPU.
;--------------------------------------------------------
;   TO HANDLE CASES SUCH AS RAM ALLOCATION, MEMORY,
;           INTERRUPTS AND ACCESS MODES
;--------------------------------------------------------

SUB_RTS             EQU         $4e75
SUB_RTE             EQU         $4e73
SUB_JMP             EQU         $4ef9

;; ACCESS MODE 1 FROM THE CARTRIDGE SLOT TO READ THE CONTENTS
;; OF A GENERIC CD

SUB_GET_WORD            EQU         $01
SUB_GET_FILE_ID         EQU         $02
SUB_LOAD_FILE_NAME      EQU         $03
SUB_LOAD_DLL_NAME       EQU         $04
SUB_PLAY_CDDA_READ      EQU         $05
SUB_PLAY_CDDA           EQU         $06
SUB_PAUSE_CDDA          EQU         $07
SUB_RESUME_CDDA         EQU         $08
SUB_STOP_CDDA           EQU         $09
SUB_FADE_CDDA           EQU         $0A
SUB_SEEK_CDDA           EQU         $0B

SUB_WORD_MODE_1_RAM             EQU             $C0000
SUB_WORD_MODE_2_RAM             EQU             $80000

SUB_MAIN_FLAG                   EQU             $ffff800e
SUB_SECOND_FLAG                 EQU             $ffff800f
SUB_COMMON_0                    EQU             $ffff8010
SUB_COMMON_2                    EQU             $ffff8012
SUB_COMMON_4                    EQU             $ffff8014
SUB_COMMON_6                    EQU             $ffff8016
SUB_COMMON_8                    EQU             $ffff8018
SUB_COMMON_10                   EQU             $ffff801a
SUB_COMMON_12                   EQU             $ffff801c
SUB_COMMON_14                   EQU             $ffff801e
SUB_STATUS_0                    EQU             $ffff8020
SUB_STATUS_2                    EQU             $ffff8022
SUB_STATUS_4                    EQU             $ffff8024
SUB_STATUS_6                    EQU             $ffff8026
SUB_STATUS_8                    EQU             $ffff8028
SUB_STATUS_10                   EQU             $ffff802a
SUB_STATUS_12                   EQU             $ffff802c
SUB_STATUS_14                   EQU             $ffff02e
SUB_PROC_RAM                    EQU             $00000000
SUB_PROC_RAM_B0                 EQU             SUB_PROC_RAM    
SUB_PROC_RAM_B1                 EQU             SUB_PROC_RAM+$20000
SUB_PROC_RAM_B2                 EQU             SUB_PROC_RAM+$40000
SUB_PROC_RAM_B3                 EQU             SUB_PROC_RAM+$60000
SUB_MEM                         EQU             $FFFF8003
SUB_DRIVE_DLL_ALIGN             EQU             $00020000
