;
; mas-cocktail.asm
;
; Created: 01-Oct-16 1:40:18 PM
; Author : galca
;
; 

 .equ F_CPU = 18432000
 .equ SHIFTDELAY = 160

 .def TEMP = R16
 .DEF TEMP2 = R18
 .DEF TEMP3 = R6
 
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
 .EQU CORDO = 1
 .EQU MEDIUM = 2
 .EQU INFANT = 3


.CSEG
		RJMP		BEGIN

.org 0x0016
		jmp			T1_B_ISR


.ORG	$500
BEGIN:

	



		LDI	R16, low(RAMEND)
		OUT	SPL, R16
		LDI	R16, high(RAMEND)
		OUT	SPH, R16
		ldi temp, 0x00
		out ddrb,temp
		out ddrd,temp
		sbi ddrc,0
		sbi ddrc,1
		sbi ddrc,2
		cli
		RCALL		KBINIT			; inicialización del teclado
		RCALL		InicI2C			; esta funcion inicializa el display, si o si tiene que ir. no hace falta modificarle nada
		RCALL		InicDisplay		; lo mismo que la anterior
		RCALL		InitUsart		; inicialización del protocolo USART para el sensor de distancia
 MAIN:	
		RCALL		DisplayWelcome					; muestra mensaje de bienvendia
		;RCALL		retardo3s						; durante 3 segundos
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
		BRNE		getk0
		RJMP		MenuBebida
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
		CPI			KEY,0x04
		BRSH		getk1a
		CPI			KEY,0x03
		BREQ		PureCoke
		STS			DRINK1,KEY
		LDI			TEMP,COCA
		STS			DRINK2,TEMP
		RJMP		MenuPotencia
PureCoke:
		LDI			TEMP,COCA
		STS			DRINK1,TEMP
		STS			DRINK2,TEMP
		LDI			TEMP,100
		STS			PERC1,TEMP
		LDI			TEMP,00
		STS			PERC2,TEMP
		RJMP		END
			
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
		CPI			KEY,0x01
		BREQ		PotCordobes
		CPI			KEY,0x02
		BREQ		PotMediA
		LDI			TEMP,25
		STS			PERC1,TEMP
		LDI			TEMP,75
		STS			PERC2,TEMP
		RJMP		END
PotCordobes:
		LDI			TEMP,75
		STS			PERC1,TEMP
		LDI			TEMP,25
		STS			PERC2,TEMP
		RJMP		END
PotMedia:
		LDI			TEMP,50
		STS			PERC1,TEMP
		LDI			TEMP,50
		STS			PERC2,TEMP
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
		STS			DRINK1,KEY
		LDI			TEMP,COCA
		STS			DRINK2,TEMP

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
		CPI			KEY,11
		BRNE		KeyNotZero
		LDI			KEY,0x00
KeyNotZero:
		LDI			TEMP,48
		ADD			KEY,TEMP
		MOV			DISPVAR,KEY
		LDI			TEMP,48
		SUB			KEY,TEMP
		RCALL		DisplayChar
		RCALL		retardo1s
		PUSH		KEY
		SBRC		PRGFLAGS,PERC
		RJMP		getPercentage
		ORI			PRGFLAGS,(1<<PERC)
		RJMP		getk2b

getPercentage:
		ANDI		PRGFLAGS,(0xFE<<PERC)
		POP			TEMP2
		POP			TEMP3
		PUSH		TEMP2
		PUSH		TEMP3
		RCALL		keyb_to_bcd
		RCALL		bcd_to_bin
		POP			TEMP2
		STS			PERC1,TEMP2
		LDI			TEMP,100
		SUB			TEMP,TEMP2
		STS			PERC2,TEMP

		

		



END:	
		
		
		RCALL		DisplayClear
		RCALL		DisplayWait
		RCALL		CreoTrago
		rcall		retardo1s
		RCALL		DisplayClear
		RCALL		DisplayDone
		rcall		retardo3s
		
		rjmp		MAIN
;---------------------------PRueba----
		ldi temp, 80
		sts perc1,temp
		ldi temp,2
		sts drink1,temp
		ldi temp, 20
		sts perc2,temp
		ldi temp,1
		sts drink2,temp

 .include "kb_driver.asm"
 .include "disp_driver.asm"
 .include "delay.asm"
 .include "interface.asm"
 .include "math.asm"
 .include "ultrasound_driver.asm"
 .include "caudal_driver.asm"


	.org 0x200
 
T1_B_ISR:
	ldi CONTROL, 0x01
	cbi portc,0
	cbi portc,1
	cbi portc,2
	ldi TEMP,0b00000000	; STOP TIMER         0b00001001  ; CTC INTERNAL clock
	sts TCCR1B,TEMP
	reti