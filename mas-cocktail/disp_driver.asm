/*
 * disp_driver.asm
 *
 *  Created: 01-Nov-16 5:01:30 PM
 *   Author: galca
 */ 
 ;
; display.asm
;
; Created: 23/9/2016 2:16:36 p. m.
; Author : waral
;
	.def TEMP = R16
	.def CONTADOR = R20
	.def DISPVAR = R24

	.equ TWI_RATE = 0xF8
	.equ STARTi = 0x08
	.equ MT_SLA_ACK = 0x20
	.equ MT_DATA_ACK= 0x28
	.equ SL_ADD = 0b01001110


;para usar el i2c no hay que inicializar nada de los puertos... 
;lo que yo puse fue para encender un led que me diga que esta todo ok


/*start:
	ldi TEMP , 0x02		; inicializacion led de error
	out ddrb , TEMP
	ldi TEMP , 0x00			
	out portb , TEMP	;esto tranquilamente se puede borrar
	
	RCALL InicI2C			; esta funcion inicializa el display, si o si tiene que ir. no hace falta modificarle nada
	RCALL InicDisplay		; lo mismo que la anterior
	RCALL DisplayCocktail	; Mando "Cocktail" al display
	RCALL DisplayEnter		; Mando "Enter" al display
	RCALL DisplayWelcome	; Mando "Welcome" al display
	


	RCALL I2CStop			; cuando finaliza el programa hay que ponerle stop al i2c
	
	ldi R16,0x02	;LED INDICADOR DE FINALIZACION OK DE PROGRAMA
	out PORTB,R16

loop:
	rjmp loop			;loop infinito

    rjmp start			;vuelve al inicio*/

;---------------------------------------------------------------------
;---------------------------------------------------------------------
;-----------------------------Fin start-------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------



;----------------------------SUBRUTINAS-------------------------------

;_____________________________________________________
;;;;;;;;;;;;;;;;;DISPLAY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
;_____________________________________________________|

;------- inicializacion i2c-------
InicI2C:	
	
	ldi TEMP, TWI_RATE
	sts TWBR,TEMP

	ldi TEMP, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)   
	sts TWCR, TEMP								;envia condicion de start

wait1:
	lds TEMP,TWCR
	sbrs TEMP,TWINT								;espera flag de start ok
	rjmp wait1

	lds TEMP,TWSR
	andi TEMP, 0xF8								;si el estado en el registro TWI es distinto de START se va a error
	cpi TEMP, STARTi
	brne error_A
	rjmp continuo
error_A:
	RCALL ERROR1
	
continuo:
	ldi TEMP, SL_ADD								
	sts TWDR, TEMP								;Carga direccion del esclavo en el registro TWDR, limpia bit TWINT para empezar la transmision de la direccion
	ldi TEMP, (1<<TWINT) | (1<<TWEN)
	sts TWCR, TEMP								;envio direccion del esclavo

wait2:
	lds TEMP,TWCR
	sbrs TEMP,TWINT								;espera seteo de TWINT para confirmar transmision ok
	rjmp wait2

	lds TEMP,TWSR
	andi TEMP, 0xF8								;chequea el registro TWI, salta a error si no se transmitio bien
	cpi TEMP, MT_SLA_ACK
	breq error_B
	rjmp continuo2
error_B:
	RCALL ERROR1
continuo2:
	ret
	
;----------------------------------Fin inicializacion i2c----------------------------------------;

;.................................incialización display, envio de a 4bits........................;
InicDisplay:	
	
	RCALL retardo50ms
	
	ldi TEMP, 0x30
	ldi r17,0x30
	sts TWDR, TEMP								; Carga DATA en twdr, limpia twint para empezar la transmision
	ldi TEMP, (1<<TWINT) |(1<<TWEN)
	sts TWCR, TEMP								
	RCALL WaitDataI2c

	RCALL DisplayEnable

	RCALL retardo5ms

	RCALL DisplayEnable

	RCALL retardo1ms
												; todo esto te lo pide que hagas la hoja de datos del display
	RCALL DisplayEnable

	RCALL retardo5ms

	ldi r16, 0x28								;set 4bit mode
	ldi r17,0x28
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16								
	RCALL WaitDataI2c
	
	RCALL DisplayEnable

	RCALL retardo1ms

	ldi TEMP,0x28								;0x28_H
	ldi r17,0x28
	sts TWDR, TEMP								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, TEMP								
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ldi TEMP,0x88								;0x28_L
	ldi r17,0x88
	sts TWDR, r16								
	ldi TEMP, (1<<TWINT) |(1<<TWEN)
	sts TWCR, TEMP								
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ldi TEMP, 0x08								;0x08_H
	ldi r17,0x08
	sts TWDR, TEMP								
	ldi TEMP, (1<<TWINT) |(1<<TWEN)
	sts TWCR, TEMP								
	RCALL WaitDataI2c

	RCALL DisplayEnable							

	ldi TEMP,0x88								;0x08_L				
	ldi r17,0x88
	
	sts TWDR, TEMP								
	ldi TEMP, (1<<TWINT) |(1<<TWEN)
	sts TWCR, TEMP								
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ldi r16,0x08								;0x01_H	
	ldi r17,0x08
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16								
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ldi r16,0x18								;0x01_L	
	ldi r17,0x18
		
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16								
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ldi r16,0x08								;0x0F_H		
	ldi r17,0x08

	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16								
	RCALL WaitDataI2c

	RCALL DisplayEnable
	
	ldi r16,0xF8								;0x0F_L	
	ldi r17,0xF8
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16								
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ldi r16,0x08							;0x06_H
	ldi r17,0x08
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)				
	sts TWCR, r16
	RCALL WaitDataI2c

	RCALL DisplayEnable

	RCALL retardo5ms
	
	ldi r16, 0x68							;0x06_L
	ldi r17, 0x68
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)				
	sts TWCR, r16
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ret

;-----------Fin Inicialización display--------------

;--DISPLAY : DATA I2C OK---;

WaitDataI2c:

wait_twint:
	lds r16,TWCR
	sbrs r16,TWINT								; Espera TWINT para confirmar que se envió ok
	rjmp wait_twint

	lds r16,TWSR
	andi r16, 0xF8
	cpi r16, MT_DATA_ACK
	brne error_data
	ret

;------DISPLAY : CHAR------;                  Con esta Funcion le enviamos un CHAR al display
DisplayChar:

	mov r16,DISPVAR							  ;En DISPVAR tiene que estar el CHAR
	andi r16,0xF0							  ;Envio DISPVAR_H
	ori r16,0x09
	mov r17,r16
	sts TWDR, r16								; Carga DATA en twdr, limpia twint para empezar la transmision
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16

	RCALL WaitDataI2c
	RCALL DisplayEnable

	mov r16,DISPVAR							  ;Envio DISPVAR_L
	lsl r16
	lsl r16
	lsl r16
	lsl r16
	ori r16,0x09
	mov r17,r16
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)				
	sts TWCR, r16
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ret

;------Display :ENTER----------

DisplayEnter:

	ldi r16,0xC8								;0x08_H
	ldi r17,0xC8
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16								
	RCALL WaitDataI2c

	RCALL DisplayEnable							

	ldi r16,0x08								;0x08_L				
	ldi r17,0x08
	
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16								
	RCALL WaitDataI2c

	RCALL DisplayEnable
ret



;----DISPLAY : STOP------

I2CStop:
	ldi r16, (1<<TWINT)|(1<<TWEN)| (1<<TWSTO)	;Transmite bit de STOP
	sts TWCR, r16
			ret

error_data:
	RCALL ERROR1


DisplayEnable:
	RCALL retardo1ms
	
	ori r17, 0x04
	sts TWDR, r17								
	ldi r16, (1<<TWINT) |(1<<TWEN)				
	sts TWCR, r16
	RCALL WaitDataI2c
;	RCALL retardo1ms

	andi r17, 0b11111011
	sts TWDR, r17								
	ldi r16, (1<<TWINT) |(1<<TWEN)				
	sts TWCR, r16
	RCALL WaitDataI2c

	;RCALL retardo1ms
	ret


;-----------Error----------------------------------

ERROR:
	
	;ldi R16,0x02
	;out PORTB,R16
	rjmp error

ERROR1:
	
	;ldi R16,0x02
	;out PORTB,R16
	ldi r16, (1<<TWINT)|(1<<TWEN)| (1<<TWSTO)	;Transmite bit de STOP
	sts TWCR, r16
	rjmp error

;------Display :CLEAR----------
DisplayClear:
	ldi r17, 0x08
	ldi	r16, 0x08
	sts TWDR, r16								; Carga DATA en twdr, limpia twint para empezar la transmision
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16

	RCALL WaitDataI2c
	RCALL DisplayEnable

	ldi r17, 0x18
	ldi r16, 0x18
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)				
	sts TWCR, r16
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ret

DisplayToggleShift:
	ldi r17, 0x18
	ldi	r16, 0x18
	sts TWDR, r16								; Carga DATA en twdr, limpia twint para empezar la transmision
	ldi r16, (1<<TWINT) |(1<<TWEN)
	sts TWCR, r16

	RCALL WaitDataI2c
	RCALL DisplayEnable

	ldi r17, 0x88
	ldi r16, 0x88
	sts TWDR, r16								
	ldi r16, (1<<TWINT) |(1<<TWEN)				
	sts TWCR, r16
	RCALL WaitDataI2c

	RCALL DisplayEnable

	ret

DisplayString:
	PUSH ZH
	PUSH ZL
	LDI CONTADOR,0x00

DisplayString_cont:
	INC CONTADOR	
	LPM DISPVAR, Z+
	CPI DISPVAR,0x00
	BRNE DisplayString_cont
	DEC CONTADOR
	POP ZL
	POP ZH

DisplayString_next:
	lpm DISPVAR, Z+
	RCALL DisplayChar

	dec  CONTADOR
	brne DisplayString_next
	
	ret



DispNum:
	

	ldi TEMP, 48
	add KEY,TEMP
	
	
DispNum_cont:
	mov DISPVAR,TEMP
	RCALL DisplayChar
	
	ret