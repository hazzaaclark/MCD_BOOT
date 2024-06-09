;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           GENERIC SEGA MEGA CD LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;    THIS FILE PERTAINS TOWARDS A SIMPLE HELLO WORLD
;           COROUTINE FOR THE BOOT LOADER
;--------------------------------------------------------

    INCLUDE "macros.asm"
    INCLUDE "BIOS_inc.asm"

VDP_CTRL_PORT   EQU $C00004
VDP_DATA_PORT   EQU $C00000

VDP_REG_00      EQU $8000
VDP_REG_01      EQU $8100
VDP_REG_02      EQU $8200
VDP_REG_03      EQU $8300
VDP_REG_04      EQU $8400

SCREEN_WIDTH    EQU 320
SCREEN_HEIGHT   EQU 240

HELLO_WORLD_TILEMAP:
    DC.W  $1000, $1001, $1002, $1003, $1004, $1005, $1006, $1007, $1008, $1009, $100A

GAME_START:
    JSR INIT_VDP
    JSR LOAD_TILE_DATA
    JSR LOAD_TILEMAP

GAME_LOOP:
    BRA GAME_LOOP

INIT_VDP:
    MOVE.W  #$8004, VDP_CTRL_PORT
    MOVE.W  #$8174, VDP_CTRL_PORT
    RTS

LOAD_TILE_DATA:
    RTS

LOAD_TILEMAP:
    MOVE.W  #$4000, VDP_CTRL_PORT
    MOVE.W  #$C000, VDP_CTRL_PORT

    LEA     HELLO_WORLD_TILEMAP, A0
    MOVEQ   #11-1, D0 

LOAD_TILEMAP_LOOP:
    MOVE.W  (A0)+, VDP_DATA_PORT
    DBF     D0, LOAD_TILEMAP_LOOP

    RTS
