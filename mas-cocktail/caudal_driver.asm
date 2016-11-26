/*
 * caudal_driver.asm
 *
 *  Created: 25-Nov-16 3:18:48 PM
 *   Author: galca
 */ 

 .equ MaxPulsos = 120
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
	LDS TEMP, 100
	MUL TEMP,TOTAL
	LDI TEMP, MaxPulsos
	call division
/*	PUSH cociente
	RCALL bin_to_bcd
	POP TEMP
	RCALL pack_bcd
	rcall bcd_to_ascii
	pop temp
	pop temp2
	mov dispvar,temp2
	rcall DisplayChar
	mov dispvar,temp
	rcall DisplayChar*/
	call imprimototal
	call retardo50ms
	rjmp loop4
ahora:	
	call retardo3s
	lds temp, drink2
	sts drink1,temp
	lds temp, perc2
	sts perc1, temp
	rcall retardo3s
	rcall retardo3s
	call CargoTrago1
	ldi CONTROL,0x00
loop5:
	
	sbrc CONTROL, 0
	jmp ahora2
	lds TOTAL,TCNT1L
	call imprimototal
	call retardo50ms
	rjmp loop5
ahora2:	
	ret

CargoTrago1:
	cli
	
	lds TEMP,perc1
	ldi TEMP2,MAxPulsos
	
	mul temp,temp2
	ldi temp,0
	mov denominadorh,temp
	ldi temp,100
	mov denominadorL,temp
	call division ;En cociente tenemos la cantidad de pulsos 

	ldi TEMP,0     
	sts OCR1AH,TEMP
	mov TEMP,cociente			;Cantidad de pulsos hasta cortar electrovalvula
	sts OCR1AL,TEMP

	ldi TEMP,0x00			;Configuro timer para external clock, pt11
	sts TCCR1A,TEMP
	ldi TEMP,0b00001110		; CTC External clock  SART         0b00001001  ; CTC INTERNAL clock
	sts TCCR1B,TEMP
	ldi TEMP,(1<<1)			 ; Interrupts enabled, compare match b
	sts TIMSK1, TEMP
	lds temp, Drink1
	cpi temp, 0x01
	breq StartEV1
	cpi temp, 0x02
	breq StartEV2
	cpi temp, 0x03
	breq StartEV3
	

EndCreoTrago:
	sei
	ret

StartEV1:
	sbi portc,0
	rjmp EndCreoTrago
StartEV2:
	sbi portc,1
	rjmp EndCreoTrago
StartEV3:
	sbi portc,2
	rjmp EndCreoTrago
/*;------Cargo TRago 2----
CargoTrago2:
	cli
	
	lds TEMP,perc2
	ldi TEMP2,MAxPulsos
	
	mul temp,temp2
	ldi temp,0
	mov denominadorh,temp
	ldi temp,100
	mov denominadorL,temp
	call division ;En cociente tenemos la cantidad de pulsos 

	ldi TEMP,0     
	sts OCR1AH,TEMP
	mov TEMP,cociente			;Cantidad de pulsos hasta cortar electrovalvula
	sts OCR1AL,TEMP

	ldi TEMP,0x00			;Configuro timer para external clock, pt11
	sts TCCR1A,TEMP
	ldi TEMP,0b00001110		; CTC External clock  SART         0b00001001  ; CTC INTERNAL clock
	sts TCCR1B,TEMP
	ldi TEMP,(1<<1)			 ; Interrupts enabled, compare match b
	sts TIMSK1, TEMP
	SBI PORTC,2
	in temp2,portc
	or temp,temp2
	out portc,temp
	sei
	ret*/
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


