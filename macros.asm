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