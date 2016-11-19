;
; mas-cocktail.asm
;
; Created: 01-Oct-16 1:40:18 PM
; Author : galca
;
; LEDs verdes: PORTD 4 y 7
; LEDs rojos: PORTC 2 y 3
 .equ CRYSTAL = 8000000
 .equ SHIFTDELAY = 160
 .EQU FERNET = 1
 .EQU WHISKY = 2
 .EQU COCA = 3
 .EQU PERC = 0

 .def TEMP = R16
 .DEF TEMP2 = R4
 .def SHIFTREGISTER = R25
 .DEF PERCENTREG = R6
 .DEF DRINK1 = R22
 .DEF DRINK2 = R23
 .def PRGFLAGS = R21
 

.CSEG
		RJMP		BEGIN




BEGIN:
		LDI	R16, low(RAMEND)
		OUT	SPL, R16
		LDI	R16, high(RAMEND)
		OUT	SPH, R16
/*		LDI			R21,'4'
		LDI			R22,'7'
		PUSH		R22
		PUSH		R21
		RCALL		keyb_to_bcd
		POP			R21
		RJMP		BEGIN*/

		LDI			R20,0XFF
		OUT			DDRC,R20
		OUT			DDRD,R20
		RCALL		KBINIT
		RCALL		InicI2C			; esta funcion inicializa el display, si o si tiene que ir. no hace falta modificarle nada
		RCALL		InicDisplay		; lo mismo que la anterior

 MAIN:	
/*		RCALL		GETKEY
		ldi			TEMP,48
		ADD			KEY,TEMP
		MOV			DISPVAR,KEY
		RCALL		DisplayChar*/
		RCALL		DisplayWelcome
		RCALL		retardo3s
		RCALL		DisplayClear
		RCALL		DisplayMenu0
		LDI			SHIFTREGISTER,SHIFTDELAY
KeyMenu0:
		RCALL		DisplayClear
		RCALL		DisplayMenu0
		RCALL		CLEARKEY
getk0:
		RCALL		Shift
		RCALL		GETKEY
		CPI			KEY,0x01
		BREQ		KeyMenu1a
		CPI			KEY,0x02
		BREQ		KeyMenu1b
		RJMP		getk0
KeyMenu1a:
		RCALL		DisplayClear
		RCALL		DisplayMenu1a
		RCALL		CLEARKEY
		RCALL		retardo1s
getk1a:
		RCALL		Shift
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk1a
		CPI			KEY,0x03
		BRSH		getk1a
KeyMenu2a:
		RCALL		DisplayClear
		RCALL		DisplayMenu2a
		RCALL		CLEARKEY
		RCALL		retardo1s
getk2a:		
		RCALL		Shift
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk2a
		CPI			KEY,0x04
		BRSH		getk2a
		RJMP		END
KeyMenu1b:
		RCALL		DisplayClear
		RCALL		DisplayMenu1b
		RCALL		CLEARKEY
		RCALL		retardo1s
getk1b:		
		RCALL		Shift
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk1b
		CPI			KEY,0x03
		BRSH		getk1b
KeyMenu2b:
		RCALL		DisplayClear
		RCALL		DisplayMenu2b
		RCALL		CLEARKEY
		RCALL		retardo1s
getk2b:	
		RCALL		CLEARKEY	
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk2b
		LDI			TEMP,48
		CPI			KEY,11
		BRNE		KeyNotZero
		LDI			KEY,0x00
KeyNotZero:
		ADD			KEY,TEMP
		MOV			DISPVAR,KEY
		RCALL		DisplayChar
		RCALL		retardo1s
		PUSH		KEY
		SBRC		PRGFLAGS,PERC
		RJMP		getPercentage
		ORI			PRGFLAGS,(1<<PERC)
		RJMP		getk2b

getPercentage:
		ANDI		PRGFLAGS,(0xFE<<PERC)
		RCALL		keyb_to_bcd
		POP			PERCENTREG

KeyMenu3b:
		RCALL		DisplayClear
		RCALL		DisplayMenu3b
		RCALL		CLEARKEY
		RCALL		retardo1s
getk3b:
		RCALL		Shift
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk3b
		CPI			KEY,0x04
		BRSH		getk3b

END:	
		RCALL		DisplayClear
		RCALL		DisplayWait
		RCALL		retardo3s
		RCALL		DisplayClear
		RCALL		DisplayDone
		RCALL		retardo3s
		RJMP		KeyMenu0

 .include "kb_driver.asm"
 .include "disp_driver.asm"
 .include "delay.asm"
 .include "interface.asm"
 .include "math.asm"
