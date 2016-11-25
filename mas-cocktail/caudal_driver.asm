/*
 * caudal_driver.asm
 *
 *  Created: 25-Nov-16 3:18:48 PM
 *   Author: galca
 */ 

 .equ MaxPulsos = 200
 .def CONTROL = R22
 .def TOTAL = R23
 .def IMPRIMO = R25


 ;________________________________________________--
;				 Caudalimetro
;__________________________________________________

;---Inicio Creacion de Trago------
CreoTrago:
	call CargoTrago1
	ldi CONTROL,0x00
loop4:
	
	sbrc CONTROL, 0
	jmp ahora
	lds TOTAL,TCNT1L
	call imprimototal
	call retardo50ms
	rjmp loop4
ahora:		
	ret

CargoTrago1:
	cli
	
	ldi TEMP,MaxPulsos
	MOV TEMP2,TEMP
	lds TEMP,PERC1
	
	mul temp,temp2
	ldi temp,0
	mov denominadorh,temp
	ldi temp,100
	mov denominadorL,temp
	call division ;En cociente tenemos la cantidad de pulsos 

	ldi TEMP,0     
	sts OCR1AH,TEMP
	mov TEMP,QUOTIENT			;Cantidad de pulsos hasta cortar electrovalvula
	sts OCR1AL,TEMP

	ldi TEMP,0x00			;Configuro timer para external clock, pt11
	sts TCCR1A,TEMP
	ldi TEMP,0b00001110		; CTC External clock  SART         0b00001001  ; CTC INTERNAL clock
	sts TCCR1B,TEMP
	ldi TEMP,(1<<1)			 ; Interrupts enabled, compare match b
	sts TIMSK1, TEMP
	lds temp, Drink1
	in temp2,portc
	or temp,temp2
	out portc,temp
	sei
	ret

;-----numero a string-----
ImprimoTotal:
		call DisplayClear

		ldi IMPRIMO,8
contimprtot:
		sbrs TOTAL,7
		rjmp CeroTotal
		rjmp UnoTotal

CeroTotal: 
		ldi DISPVAR,'0'
		call DisplayChar
		dec IMPRIMO
		breq finImprimo
		lsL TOTAL
		rjmp contimprtot
UnoTotal:
		ldi DISPVAR,'1'
		call DisplayChar
		dec IMPRIMO
		breq finImprimo
		lsL TOTAL
		rjmp contimprtot
FinImprimo:
ret



T1_B_ISR:
	ldi CONTROL, 0x01
	cbi portc,0
	cbi portc,1
	cbi portc,2
	ldi TEMP,0b00000000	; STOP TIMER         0b00001001  ; CTC INTERNAL clock
	sts TCCR1B,TEMP
	reti