;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;  THIS FILE PERTAINS TOWARDS THE FUNCTIONALITY SURROUDNING
;   SYSTEM FUNCTIONS, SUCH AS DECLARATIONS OF THE VDP
;--------------------------------------------------------

;--------------------------------------------------------
;       SETUP THE VDP AND DEFINE RELEVANT DIRECTIVES
;--------------------------------------------------------

VDP_DATA            EQU     $C00000
VDP_CTRL            EQU     $C00004

VDP_SETTINGS:

    DC.B        $00
    DC.B        $04
    DC.B        $30
    DC.B        $3C 
	DC.B        $07 
	DC.B        $6C
	DC.B        $00    
	DC.B        $00
	DC.B        $00
	DC.B        $00
	DC.B        $FF
	DC.B        $00 
	DC.B        $81 
	DC.B        $37
	DC.B        $00
	DC.B        $02
	DC.B        $01 
	DC.B        $00 
	DC.B        $00 
	DC.B        $FF 
	DC.B        $FF
	DC.B        $00 
	DC.B        $00 
	DC.B        $80

VDP_END:
    EVEN

FONT:
    INCBIN "Font96.FNT"
FONT_END:

INIT_VDP:
    LEA     VDP_SETTINGS, A5
    MOVE.L  #VDP_END-VDP_SETTINGS, D1       ;; EVALUATE THE SIZE OF THE VDP (PREVENTS OVERFLOW)
    MOVE.W  (VDP_CTRL), D0                  ;; READ VDP CONTROL STATUS INTO D0
    MOVE.W  #$00008000, D5

    MOVE.B  (A5)+, D5                       ;; GET NEXT VIDEO CONTROL BYTE
    MOVE.W  D5, (VDP_CTRL)                  ;; SEND WRITE COMMAND TO VDP
    ADD.W   #$0100, D5                      ;; POINTER OFFSET TO NEXT VDP COMMAND
    DBRA    D1, INIT_VDP                    ;; BRANCH BASED OFF A DATA REGISTER DIRECTIVE                     
