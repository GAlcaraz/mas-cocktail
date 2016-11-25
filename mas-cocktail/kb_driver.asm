/*
 * kb_driver.asm
 *
 *  Created: 25-Oct-16 10:23:47 PM
 *   Author: galca
 */ 

.EQU COL1 = PINB0
.EQU COL2 = PINB1
.EQU COL3 = PINB2

.EQU ROW1 = PINB3
.EQU ROW2 = PINC3
.EQU ROW3 = PINB5
.EQU ROW4 = PINB4

.EQU ROW1VAL = 1
.EQU ROW2VAL = 4
.EQU ROW3VAL = 7
.EQU ROW4VAL = 10

.EQU KBPORT = PORTB
.EQU PRESSED = 7
.EQU KBCONF = 0xF8
.EQU KBPULLUPS = 0x07
 

.DEF KBTEMP = R17
.DEF KEY = R19
 
.CSEG

KBINIT:
		PUSH		KBTEMP
 		LDI			KBTEMP,KBCONF		;cols como input, filas como output
		OUT			DDRB,KBTEMP
		IN			KBTEMP,DDRC
		ORI			KBTEMP,(0<<PINC3)
		OUT			DDRC,TEMP
		LDI			KBTEMP,KBPULLUPS		;habilitar pullups en el input
		OUT			KBPORT,KBTEMP
		POP			KBTEMP	
		RET

 GETKEY:
												;Esta sección lee la fila 1
		LDI			KEY,ROW1VAL					;carga el valor de la primera tecla de la fila 1 en "key"
		LDI			KBTEMP,~(1<<ROW1)			;"apaga" fila 1 (carga un byte de unos con un único cero en la posición "ROW1")
		OUT			KBPORT,KBTEMP				;y cargando el valor al puerto usado por el teclado
		RCALL		READ_COL					;se pasa a leer las columnas, esperando encontrar coincidencias
		
 
		SBRC		PRGFLAGS,PRESSED				;si se registró una tecla presionada
		RJMP		DONE						;salir de la subrutina
 
												;Esta sección lee la fila 2
/*		LDI			KEY,ROW2VAL					;carga el valor de la primera tecla de la fila 2 en "key"
		IN			KBTEMP,PORTC
		ANDI		KBTEMP,(1<<PINC3)			;"apaga" fila 2 (carga un byte de unos con un único cero en la posición "ROW2")
		OUT			PORTC,KBTEMP				;y cargando el valor al puerto usado por el teclado
		RCALL		READ_COL					;se pasa a leer las columnas, esperando encontrar coincidencias
 
		SBRC		PRGFLAGS,PRESSED				;si se registró una tecla presionada
		RJMP		DONE						;salir de la subrutina*/
												
												;Esta sección lee la fila 3
		LDI			KEY,ROW3VAL					;carga el valor de la primera tecla de la fila 3 en "key"
		LDI			KBTEMP,~(1<<ROW3)			;"apaga" fila 3 (carga un byte de unos con un único cero en la posición "ROW3")
		OUT			KBPORT,KBTEMP				;y cargando el valor al puerto usado por el teclado
		RCALL		READ_COL					;se pasa a leer las columnas, esperando encontrar coincidencias

		SBRC		PRGFLAGS,PRESSED				;si se registró una tecla presionada
		RJMP		DONE						;salir de la subrutina
 
												;Esta sección lee la fila 4
		LDI			KEY,ROW4VAL					;carga el valor de la primera tecla de la fila 4 en "key"
		LDI			KBTEMP,~(1<<ROW4)			;"apaga" fila 4 (carga un byte de unos con un único cero en la posición "ROW4")
		OUT			KBPORT,KBTEMP				;y cargando el valor al puerto usado por el teclado
		RCALL		READ_COL					;se pasa a leer las columnas, esperando encontrar coincidencias*/
 
DONE:					
		RET
 
READ_COL:
		RCALL		SETTLE
		CBR			PRGFLAGS, (1<<PRESSED)		;estado = no presionado
 
		SBIC		PINB, COL1					;lee columna 1
		RJMP		NEXTCOL						;si no, pasar a columna 2
		SBR			PRGFLAGS, (1<<PRESSED)		;estado = presionado
		RET										;devolver el valor de la primer columna de la fila
NEXTCOL:
		RCALL		SETTLE
		SBIC		PINB,COL2					;lee columna 2
		RJMP		NEXTCOL1					;si no, pasar a columna 3
		INC			KEY							
		SBR			PRGFLAGS,(1<<PRESSED)		;estado = presionado
		RET										;devolver el valor de la segunda columna de la fila
NEXTCOL1:
		RCALL		SETTLE
		SBIC		PINB,COL3					;lee columna 3
		RJMP		EXIT						;si no, termina
		INC			KEY							;estado = presionado
		INC			KEY
		SBR			PRGFLAGS, (1<<PRESSED)		;estado=presionado
		RET										;devolver el valor de la tercer columna de la fila
EXIT:
		CLR			KEY							;vacía el valor de la tecla
		CBR			PRGFLAGS, (1<<PRESSED)		;no se presionó ninguna tecla
		RET										
SETTLE:
		LDI			KBTEMP,255
TAGAIN: DEC			KBTEMP
		BRNE		TAGAIN
		RET 

CLEARKEY:
		LDI			KEY,0X00
		RET