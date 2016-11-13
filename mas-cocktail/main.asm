;
; mas-cocktail.asm
;
; Created: 01-Oct-16 1:40:18 PM
; Author : galca
;
; LEDs verdes: PORTD 4 y 7
; LEDs rojos: PORTC 2 y 3
 .equ CRYSTAL = 8000000

.CSEG
		RJMP		BEGIN




BEGIN:
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

KeyMenu0:		
		RCALL		GETKEY
		CPI			KEY,0x01
		BREQ		KeyMenu1a
		CPI			KEY,0x02
		BREQ		KeyMenu1b
		RJMP		KeyMenu0
KeyMenu1a:
		RCALL		DisplayClear
		RCALL		DisplayMenu1a
getk1a:
		RCALL		GETKEY
		CPI			KEY,0x04
		BRSH		getk1a
KeyMenu2a:
		RCALL		DisplayClear
		RCALL		DisplayMenu2a
getk2a:		
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk2a
		CPI			KEY,0x03
		BRSH		getk2a
		RJMP		END
KeyMenu1b:
		RCALL		DisplayClear
		RCALL		DisplayMenu1b
getk1b:		
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk1b
		CPI			KEY,0x03
		BRSH		getk1b
KeyMenu2b:
		RCALL		DisplayClear
		RCALL		DisplayMenu2b
getk2b:		
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk2b
		CPI			KEY,0x03
		BRSH		getk2b
KeyMenu3b:
		RCALL		DisplayClear
		RCALL		DisplayMenu3b
		RCALL		GETKEY

END:
		RJMP		KeyMenu0

 .include "kb_driver.asm"
 .include "disp_driver.asm"
 .include "delay.asm"
 .include "interface.asm"
