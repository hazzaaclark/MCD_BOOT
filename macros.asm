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
INCLUDE         "BIOS_inc.asm"
;--------------------------------------------------------

MACRO           ALIGN
NOP             0, \1
ENDM

;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO THE
;              SUB-ROUTINE OF THE CDDA AND
;             SUBSEQUENT BIOS FUNCTIONALITY
;--------------------------------------------------------

;; INITALISE THE BIOS BASED ON THE DIRECTIVE VALUE
;; MOVE ALL CORRESPONDING BOOT INFORMATION INTO D0
;; AND JUMP SUB ROUTINE TO BIOS BOOT 

CD_BIOS         MACRO           CD_BIOS_INIT

MOVEQ           #0, D0
MOVE.W          \CD_BIOS_INIT,D0
JSR             _CDBIOS
ENDM

;; CALL THE BACKUP RAM IN CASE OF ADDITIONAL MEANS 
;; FOR READING AND PARSING DISC CONTENTS

BURAM           MACRO           CD_BIOS_INIT

MOVE.W          \CD_BIOS_INIT, D0
JSR             _BURAM
ENDM   

;; READ THE STACK TRACE FROM OFFSET $01 TO CLOSE THE DISK TRAY
;; FROM THERE, IT WILL DETERMINE IF REG 7 HAS BEEN SET TO READ THE FIRST
;; TRACK OF THE ISO/CUE

BIOS_DRV_INIT       MACRO
CD_BIOS             #DRVINIT
ENDM

;; ADVERSLY, DETERMINE WHEN THE DISK DRIVE IS OPEN

BIOS_DRV_OPEN           MACRO
CD_BIOS                 #DRVOPEN
ENDM

;; MUSIC MACROS - ENABLES THE CDDA SUPPORT

BIOS_MUSIC_STOP         MACRO
CD_BIOS                 #MSCSTOP
ENDM


BIOS_MUSIC_PLAY         MACRO
CD_BIOS                 #MSCPLAY
ENDM


BIOS_MUSIC_PLAY1        MACRO
CD_BIOS                 #MSCPLAY1
ENDM

BIOS_MUSIC_PLAYER       MACRO
CD_BIOS                 #MSCPLAYR
#ENDM


BIOS_MUSIC_PLAYER_TIME  MACRO
CD_BIOS                 #MSCPLAYT
ENDM


BIOS_MUSIC_SEEK         MACRO
CD_BIOS                 #MSCSEEK
ENDM


BIOS_MUSIC_SEEK_ONCE    MACRO
CD_BIOS                 #MSCSEEK1
ENDM


BIOS_MUSIC_SEEK_TIMER   MACRO
CD_BIOS                 #MSCSEEKT
ENDM


BIOS_MUSIC_PAUSE_ON      MACRO
CD_BIOS                  #MSCPAUSEON
ENDM


BIOS_MUSIC_PAUSE_OFF     MACRO
CD_BIOS                  #MSCPAUSEOFF
ENDM


BIOS_MUSIC_SCANFF       MACRO
CD_BIOS                 #MSCSCANFF
ENDM


BIOS_MUSIC_SCANBW       MACRO
CD_BIOS                 #MSCSCANFR
ENDM


BIOS_MUSIC_SCAN_OFF     MACRO
CD_BIOS_INIT            #MSCSCANOFF
ENDM


;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO THE
;               SUB-ROUTINE OF THE CD-ROM
;--------------------------------------------------------

BIOS_ROM_READ           MACRO
CD_BIOS                 #ROMREAD
ENDM

BIOS_ROM_READ_SECTOR    MACRO
CD_BIOS                 #ROMREADN
ENDM

BIOS_ROM_READ_ENDIAN    MACRO
CD_BIOS                 #ROMREADE
ENDM

BIOS_ROM_SEEK           MACRO
CD_BIOS                 #ROMSEEK
ENDM

BIOS_ROM_PAUSE_ON       MACRO
CD_BIOS                 #ROMPAUSEON
ENDM

BIOS_ROM_PAUSE_OFF      MACRO
CD_BIOS                 #ROMPAUSEOFF

;--------------------------------------------------------
;       THE FOLLOWING DEFINES ARE IN RELATION TO THE
;               SUB-ROUTINE OF THE SUB CPU.
;--------------------------------------------------------
;   TO HANDLE CASES SUCH AS RAM ALLOCATION, MEMORY,
;           INTERRUPTS AND ACCESS MODES
;--------------------------------------------------------

SUB_CPU_DEFINES:

SUB_RTS             EQU         $4E75
SUB_RTE             EQU         $4E73
SUB_JMP             EQU         $4EF9

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

SUB_WORD_MODE_1_RAM             EQU             $000c0000
SUB_WORD_MODE_2_RAM             EQU             $00080000

SUB_MAIN_FLAG                   EQU             $FFFF800E
SUB_SECOND_FLAG	                EQU	            $FFFF800F
SUB_COMMON_0                    EQU	            $FFFF8010
SUB_COMMON_2		            EQU	            $FFFF8012
SUB_COMMON_4		            EQU	            $FFFF8014
SUB_COMMON_6                    EQU	            $FFFF8016
SUB_COMMON_8		            EQU	            $FFFF8018
SUB_COMMON_10	                EQU	            $FFFF801A
SUB_COMMON_12	                EQU	            $FFFF801C
SUB_COMMON_14	                EQU             $FFFF801E
SUB_STATUS_0		            EQU	            $FFFF8020
SUB_STATUS_2		            EQU             $FFFF8022
SUB_STATUS_4		            EQU             $FFFF8024
SUB_STATUS_6		            EQU	            $FFFF8026
SUB_STATUS_8		            EQU             $FFFF8028
SUB_STATUS_10	                EQU             $FFFF802A
SUB_STATUS_12	                EQU             $FFFF802C
SUB_STATUS_14	                EQU             $FFFF02E
SUB_PROC_RAM	                EQU             $00000000
SUB_PROC_RAM_B0	                EQU	            SUB_PROC_RAM	
SUB_PROC_RAM_B1	                EQU	            SUB_PROC_RAM+$20000
SUB_PROC_RAM_B2	                EQU	            SUB_PROC_RAM+$40000
SUB_PROC_RAM_B3	                EQU             SUB_PROC_RAM+$60000
SUB_MEM	                        EQU	            $FFFF8003
