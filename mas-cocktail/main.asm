;
; mas-cocktail.asm
;
; Created: 01-Oct-16 1:40:18 PM
; Author : galca
;
; LEDs verdes: PORTD 4 y 7
; LEDs rojos: PORTC 2 y 3

		LDI			R20,0XFF
		OUT			DDRC,R20
		OUT			DDRD,R20
		RCALL		KBINIT
		RCALL		InicI2C			; esta funcion inicializa el display, si o si tiene que ir. no hace falta modificarle nada
		RCALL		InicDisplay		; lo mismo que la anterior

 MAIN:	
		RCALL		GETKEY
		ldi			TEMP,48
		ADD			KEY,TEMP
		MOV			DISPVAR,KEY
		RCALL		DisplayChar

		

/*		SER			R22
		OUT			PORTC,R22
		OUT			PORTD,R22
 BCD1:	MOV			R18,R19
		ANDI		R18,0X08
		BREQ		BCD2
		CBI			PORTD,4
BCD2:	MOV			R18,R19
		ANDI		R18,0X04
		BREQ		BCD3
		CBI			PORTD,7
BCD3:	MOV			R18,R19
		ANDI		R18,0X02
		BREQ		BCD4
		CBI			PORTC,2
BCD4:	MOV			R18,R19
		ANDI		R18,0X01
		BREQ		MAIN
		CBI			PORTC,3*/
		/*RCALL I2CStop*/
		RJMP		MAIN

 .include "kb_driver.asm"
 .include "disp_driver.asm"
