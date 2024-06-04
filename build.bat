@echo off

ECHO BUILDING SECURITY SECTOR
asm68k /p security.asm, security.bin

ECHO BUILDING BIOS
asm68k /p BIOS.asm, BIOS.bin

ECHO BUILDING MAIN SECTOR
asm68k /p main.asm, main.bin

ECHO BUILDING ISO
mkisofs -iso-level 1 -G main.bin -o out.iso -pad _filesystem main.bin

pause
