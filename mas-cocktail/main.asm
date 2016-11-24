;
; mas-cocktail.asm
;
; Created: 01-Oct-16 1:40:18 PM
; Author : galca
;
; LEDs verdes: PORTD 4 y 7
; LEDs rojos: PORTC 2 y 3
 .equ F_CPU = 18432000
 .equ SHIFTDELAY = 160

 .def TEMP = R16
 .DEF TEMP2 = R5
 .DEF TEMP3 = R6
 .DEF PERCENTREG = R6
/* .DEF DRINK1 = R22
 .DEF DRINK2 = R23*/
 .def PRGFLAGS = R21

 ;----------------------------------------------------------
 ;----------------------------------------------------------
 ;----------------PARÁMETROS DE LAS BEBIDAS-----------------
 ;----------------------------------------------------------
 ;----------------------------------------------------------

 .EQU FERNET = 1
 .EQU WHISKY = 2
 .EQU COCA = 3
 .EQU PERC = 0
 .EQU PERC1 = $1400
 .EQU PERC2 = $1401
 .EQU DRINK1 = $1402
 .EQU DRINK2 = $1403

.CSEG
		RJMP		BEGIN



.ORG	$500
BEGIN:
		LDI	R16, low(RAMEND)
		OUT	SPL, R16
		LDI	R16, high(RAMEND)
		OUT	SPH, R16








		RCALL		KBINIT			; inicialización del teclado
		RCALL		InicI2C			; esta funcion inicializa el display, si o si tiene que ir. no hace falta modificarle nada
		RCALL		InicDisplay		; lo mismo que la anterior
		RCALL		InitUsart		; inicialización del protocolo USART para el sensor de distancia


getk2b:	
		RCALL		CLEARKEY	
		RCALL		GETKEY
		CPI			KEY,0x00
		BREQ		getk2b
		CPI			KEY,11
		BRNE		KeyNotZero
		LDI			KEY,0x00
KeyNotZero:
		RCALL		retardo1s
		MOV			TEMP2,KEY
		SBRC		PRGFLAGS,PERC
		RJMP		getPercentage
		ORI			PRGFLAGS,(1<<PERC)
		MOV			TEMP3,TEMP2
		RJMP		getk2b

getPercentage:
		ANDI		PRGFLAGS,(0xFE<<PERC)

		PUSH		TEMP2
		PUSH		TEMP3

		RCALL		keyb_to_bcd
		POP			TEMP2
		STS			PERC1,TEMP2
		PUSH		TEMP2
		RCALL		bcd_to_bin
		POP			TEMP2
		LDI			TEMP,100
		SUB			TEMP,TEMP2
		PUSH		TEMP
		RCALL		bin_to_bcd
		POP			TEMP
		RCALL		pack_bcd
		POP			TEMP
		STS			PERC2,TEMP


		lds TEMP,PERC1
		PUSH TEMP
		rcall bcd_to_ascii
		pop temp
		mov dispvar,temp
		rcall DisplayChar
		pop temp
		mov dispvar,temp
		rcall DisplayChar

		lds TEMP,PERC2
		PUSH TEMP
		rcall bcd_to_ascii
		pop temp
		mov dispvar,temp
		rcall DisplayChar
		pop temp
		mov dispvar,temp
		rcall DisplayChar

		here:
		rjmp here
/*



		RCALL		KBINIT			; inicialización del teclado
		RCALL		InicI2C			; esta funcion inicializa el display, si o si tiene que ir. no hace falta modificarle nada
		RCALL		InicDisplay		; lo mismo que la anterior
		RCALL		InitUsart		; inicialización del protocolo USART para el sensor de distancia
 MAIN:	
		RCALL		DisplayWelcome					; muestra mensaje de bienvendia
		RCALL		retardo3s						; durante 3 segundos
		RCALL		DisplayClear					; borra el display
		RCALL		DisplayMenu0					; empieza el programa en si
		LDI			TEMP,SHIFTDELAY					; settea el contador de velocidad de shifteo del display
MenuModo:
		RCALL		DisplayClear
		RCALL		DisplayMenu0
		RCALL		CLEARKEY
getk0:
		RCALL		Shift
		RCALL		GETKEY
		CPI			KEY,0x01
		BREQ		MenuTrago
		CPI			KEY,0x02
		BREQ		MenuBebida
		RJMP		getk0
MenuTrago:
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
MenuPotencia:
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
MenuBebida:
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
MenuPorc:
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
		POP			TEMP2
		STS			PERC1,TEMP2
		LDI			TEMP,100
		SUB			TEMP,TEMP2
		STS			PERC2,TEMP*/


END:	
		RCALL		DisplayClear
		RCALL		DisplayWait
		RCALL		retardo1s
		RCALL		DisplayClear
		RCALL		DisplayDone
		RCALL		retardo1s
		RCALL		DisplayClear
		RCALL measurement

		RCALL bin_to_bcd
		RCALL bcd_to_ascii
		pop r16
		mov DISPVAR,r16
		RCALL DisplayChar
		pop r16
		mov DISPVAR,r16
		RCALL DisplayChar
		pop r16
		mov DISPVAR,r16
		RCALL DisplayChar
		RCALL retardo3s
		pop r16
		RJMP		here

 .include "kb_driver.asm"
 .include "disp_driver.asm"
 .include "delay.asm"
 .include "interface.asm"
 .include "math.asm"
 .include "ultrasound_driver.asm"



 