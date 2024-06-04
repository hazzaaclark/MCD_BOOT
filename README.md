# MCD_BOOT

A Generic, all purpose solution to sideloading custom software onto the SEGA MEGA CD

## Motive:

This project serves to provide the sole foundation by which developers are able to create software for the MEGA CD

Sideloading your own content onto the console through this bootloader, which houses all of the necessary functionality for getting started

## Featuring the following:

- CDDA Support (in compliance with BIOS standard)

- Relevant header checks and subroutines for working natively

- Functionality for statically casted macros for ease of use development

- (WIP) PCM audio driver support for full 44100KHz audio

## Showcase:

- SEGA MEGA CD - JPN BIOS (V1.00p M1)

![image](https://github.com/hazzaaclark/MCD_BOOT/assets/107435091/c7414329-9ba5-417c-bede-6e4a10b4c41d)


- SEGA MEGA CD - JUE BIOS (V2.00 M2)

![image](https://github.com/hazzaaclark/MCD_BOOT/assets/107435091/04eefcb4-855b-43d4-a64c-77be32499a07)

- SEGA CD - USA BIOS (V1.10 M1)

![image](https://github.com/hazzaaclark/MCD_BOOT/assets/107435091/bd089f5c-f92e-4920-910e-4faf962d2572)


## Development:

The means to developing within the confinements of this boot loader go as per any other SEGA console development

Whereby all of the pre-requsities that you can change to accomodate for your software can always be found in ``main.asm``

Change REGION, DOMESTIC/OVERSEAS AND DISK ID to meet your needs

![image](https://github.com/hazzaaclark/MCD_BOOT/assets/107435091/d50ae2ad-0319-4605-98b3-6bcd78267a0e)
