;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------
;--------------------------------------------------------
;          THIS FILE PERTAINS TOWARDS THE MAIN       
;              FUNCTIONALITY OF THE PROGRAM
;--------------------------------------------------------

CD_HEADER:

DISC_TYPE:              DC.B            'SEGADISCSYSTEM  '
VOLUME_NAME:            DC.B            'SEGACDGAME     ', 0
VOLUME_SYSTEM:          DC.W            $100, $1
SYSTEM_NAME:            DC.B            'SEGACDGAME     ', 0
SYSTEM_VER:             DC.W            0,0
IP_ADDR:                DC.L            $800
IP_SIZE:                DC.L            $800
IP_ENTRY:               DC.L            0
IP_WORK_RAM:            DC.L            0
SP_SIZE:                DC.L            0
SP_ENTRY:               DC.L            0
SP_ADDR:                DC.L            $1000
SP_SIZE:                DC.L            $7200


GAME_HEADER:  

HARDWARE_TYPE:          DC.B            'SEGA MEGA DRIVE    '
COPYRIGHT:              DC.B            '(C)HARRY CLARK 2024'
DOMESTIC_NAME:          DC.B            'SEGA CD LOADER'
DISK_ID:                DC.B            'GM XX-XXXX-XX              '
IO:                     DC.B            'J                          '
REGION:                 DC.B            'JUE                        '
