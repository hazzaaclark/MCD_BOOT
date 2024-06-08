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