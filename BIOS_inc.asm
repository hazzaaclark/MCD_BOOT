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

;--------------------------------------------------------
;   HERE IS A LARGE AND VERBOSE LIST OF ALL OF THE 
;   CORRESPONDENCE OF A GENERIC SEGA MEGA CD BIOS LOADER
;--------------------------------------------------------

;--------------------------------------------------------
;       THE PURPOSE IS SIMILAR TO THAT OF THE MD'S
;       VECTOR TABLE, IN BEING ABLE TO COMMUNICATE
;       BETWEEN CPU'S (SUCH IS THE CASE WITH MCD)
;--------------------------------------------------------

MSCSTOP           EQU   $0002
MSCPAUSEON        EQU   $0003
MSCPAUSEOFF       EQU   $0004
MSCSCANFF         EQU   $0005
MSCSCANFR         EQU   $0006
MSCSCANOFF        EQU   $0007
ROMPAUSEON        EQU   $0008
ROMPAUSEOFF       EQU   $0009
DRVOPEN           EQU   $000A
DRVINIT           EQU   $0010
MSCPLAY           EQU   $0011
MSCPLAY1          EQU   $0012
MSCPLAYR          EQU   $0013
MSCPLAYT          EQU   $0014
MSCSEEK           EQU   $0015
MSCSEEKT          EQU   $0016
ROMREAD           EQU   $0017
ROMSEEK           EQU   $0018
MSCSEEK1          EQU   $0019
TESTENTRY         EQU   $001E
TESTENTRYLOOP     EQU   $001F
ROMREADN          EQU   $0020
ROMREADE          EQU   $0021
CDBCHK            EQU   $0080
CDBSTAT           EQU   $0081
CDBTOCWRITE       EQU   $0082
CDBTOCREAD        EQU   $0083
CDBPAUSE          EQU   $0084
FDRSET            EQU   $0085
FDRCHG            EQU   $0086
CDCSTART          EQU   $0087
CDCSTARTP         EQU   $0088
CDCSTOP           EQU   $0089
CDCSTAT           EQU   $008A
CDCREAD           EQU   $008B
CDCTRN            EQU   $008C
CDCACK            EQU   $008D
SCDINIT           EQU   $008E
SCDSTART          EQU   $008F
SCDSTOP           EQU   $0090
SCDSTAT           EQU   $0091
SCDREAD           EQU   $0092
SCDPQ             EQU   $0093
SCDPQL            EQU   $0094
LEDSET            EQU   $0095
CDCSETMODE        EQU   $0096
WONDERREQ         EQU   $0097
WONDERCHK         EQU   $0098
CBTINIT           EQU   $0000
CBTINT            EQU   $0001
CBTOPENDISC       EQU   $0002
CBTOPENSTAT       EQU   $0003
CBTCHKDISC        EQU   $0004
CBTCHKSTAT        EQU   $0005
CBTIPDISC         EQU   $0006
CBTIPSTAT         EQU   $0007
CBTSPDISC         EQU   $0008
CBTSPSTAT         EQU   $0009
BRMINIT           EQU   $0000
BRMSTAT           EQU   $0001
BRMSERCH          EQU   $0002
BRMREAD           EQU   $0003
BRMWRITE          EQU   $0004
BRMDEL            EQU   $0005
BRMFORMAT         EQU   $0006
BRMDIR            EQU   $0007
BRMVERIFY         EQU   $0008

;-----------------------------------------------------------------------
; BIOS ENTRY POINTS
;-----------------------------------------------------------------------

_ADRERR           EQU   $00005F40
_BOOTSTAT         EQU   $00005EA0
_BURAM            EQU   $00005F16
_CDBIOS           EQU   $00005F22
_CDBOOT           EQU   $00005F1C
_CDSTAT           EQU   $00005E80
_CHKERR           EQU   $00005F52
_CODERR           EQU   $00005F46
_DEVERR           EQU   $00005F4C
_LEVEL1           EQU   $00005F76
_LEVEL2           EQU   $00005F7C
_LEVEL3           EQU   $00005F82 
_LEVEL4           EQU   $00005F88
_LEVEL5           EQU   $00005F8E
_LEVEL6           EQU   $00005F94
_LEVEL7           EQU   $00005F9A
_NOCOD0           EQU   $00005F6A
_NOCOD1           EQU   $00005F70
_SETJMPTBL        EQU   $00005F0A
_SPVERR           EQU   $00005F5E
_TRACE            EQU   $00005F64
_TRAP00           EQU   $00005FA0
_TRAP01           EQU   $00005FA6
_TRAP02           EQU   $00005FAC
_TRAP03           EQU   $00005FB2
_TRAP04           EQU   $00005FB8
_TRAP05           EQU   $00005FBE
_TRAP06           EQU   $00005FC4
_TRAP07           EQU   $00005FCA
_TRAP08           EQU   $00005FD0
_TRAP09           EQU   $00005FD6
_TRAP10           EQU   $00005FDC
_TRAP11           EQU   $00005FE2
_TRAP12           EQU   $00005FE8
_TRAP13           EQU   $00005FEE
_TRAP14           EQU   $00005FF4
_TRAP15           EQU   $00005FFA
_TRPERR           EQU   $00005F58
_USERCALL0        EQU   $00005F28 ;INIT
_USERCALL1        EQU   $00005F2E ;MAIN
_USERCALL2        EQU   $00005F34 ;VINT
_USERCALL3        EQU   $00005F3A ;NOT DEFINED
_USERMODE         EQU   $00005EA6
_WAITVSYNC        EQU   $00005F10
