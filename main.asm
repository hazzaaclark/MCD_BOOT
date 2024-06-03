;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------
;          THIS FILE PERTAINS TOWARDS THE MAIN
;              FUNCTIONALITY OF THE PROGRAM
;--------------------------------------------------------

    INCLUDE "macros.asm"
    INCLUDE "BIOS_inc.asm"

;---------------------------------------
;           SEGA MEGA CD HEADER
;---------------------------------------

DISC_TYPE:      DC.B    'SEGADISCSYSTEM  '
VOLUME_NAME:    DC.B    'SEGACDGAME     ',0
VOLUME_SYSTEM:  DC.W    $100, $1
SYSTEM_NAME:    DC.B    'SEGACDGAME     ',0
SYSTEM_VER:     DC.W    0,0
IP_ADDR:        DC.L    $800
IP_SIZE:        DC.L    $800
IP_ENTRY:       DC.L    0
IP_WORK_RAM:    DC.L    0
SP_SIZE:        DC.L    0
SP_ENTRY:       DC.L    0
SP_ADDR:        DC.L    $1000
SP_SIZE_FINAL:  DC.L    $7200
SP_WORK_RAM:    DC.L    0
                ALIGN   $100 

;---------------------------------------
;               GAME HEADER
;---------------------------------------

HARDWARE_TYPE:  DC.B 'SEGA MEGA DRIVE '
COPYRIGHT:      DC.B '                  HARRY CLARK         '
NATIVE_NAME:    DC.B 'SEGA CD LOADER                                        '
OVERSEAS_NAME:  DC.B 'SEGA CD LOADER                                        '
DISK_ID:        DC.B 'GM XX-XXXX-XX  '
IO:             DC.B 'J              '
                ALIGN   $1F0
REGION:         DC.B 'JUE          '

;--------------------------------------------------------
;                   SUB CPU COUROUTINE
;--------------------------------------------------------

    ALIGN $1000
    include "BIOS.asm"
    ALIGN $8000


