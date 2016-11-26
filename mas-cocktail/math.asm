/*
 * math.asm
 *
 *  Created: 18-Nov-16 11:18:15 AM
 *   Author: galca
 */ 

 .DEF	DENOMINATOR = R2
 .DEF	QUOTIENT = R3
 .DEF	NUM = R4
 .def	numeradorL = R0
 .def	numeradorH = R1
 .def	denominadorL = R10
 .def	denominadorH = R11
 .def cociente = r12

keyb_to_bcd:
		POP			ZH
		POP			ZL
		POP			TEMP
		ANDI		TEMP,0x0F
		SWAP		TEMP

		MOV			TEMP2,TEMP
		POP			TEMP
		ANDI		TEMP,0x0F
		OR			TEMP,TEMP2
		PUSH		TEMP
		PUSH		ZL
		PUSH		ZH

		RET

bcd_to_bin:
		POP			ZH
		POP			ZL
		POP			TEMP
		PUSH		TEMP
		ANDI		TEMP,0x0F
		MOV			TEMP2,TEMP
		POP			TEMP
		SWAP		TEMP
		ANDI		TEMP,0x0F
		MOV			TEMP3,TEMP
		LDI			TEMP,10
		MUL			TEMP3,TEMP
		MOVW		TEMP3,R0
		ADC			TEMP3,TEMP2
		PUSH		TEMP3
		PUSH		ZL
		PUSH		ZH
		
		RET


bcd_to_ascii:
		POP			ZH
		POP			ZL
		POP			TEMP
		PUSH		TEMP
		ANDI		TEMP,0x0F
		ORI			TEMP,0x30

		MOV			TEMP2,TEMP
		POP			TEMP
		PUSH		TEMP2
		SWAP		TEMP
		ANDI		TEMP,0x0F
		ORI			TEMP,0x30
		PUSH		TEMP

		PUSH		ZL
		PUSH		ZH
		RET

pack_bcd:
		POP			ZH
		POP			ZL
		POP			TEMP2
		POP			TEMP
		SWAP		TEMP2
		OR			TEMP,TEMP2
		PUSH		TEMP
		PUSH		ZL
		PUSH		ZH
		RET

bin_to_bcd:
		POP			ZH
		POP			ZL
		POP			NUM
		LDI			TEMP,10
		MOV			DENOMINATOR,TEMP
		RCALL		DIVIDE
		MOV			TEMP,NUM
		MOV			NUM,TEMP
		PUSH		NUM
		MOV			NUM,QUOTIENT
		RCALL		DIVIDE
		MOV			TEMP,NUM
		MOV			NUM,TEMP
		PUSH		NUM
		MOV			TEMP,QUOTIENT
		MOV			QUOTIENT,TEMP
		PUSH		QUOTIENT
		PUSH		ZL
		PUSH		ZH
		RET

DIVIDE:
		LDI			TEMP,0
		MOV			QUOTIENT,TEMP
DIVLOOP:
		INC			QUOTIENT
		SUB			NUM,DENOMINATOR
		BRCC		DIVLOOP
		DEC			QUOTIENT
		ADD			NUM,DENOMINATOR
		RET


;----------------Operaciones matem�ticas---------------

;---Division--
division:
	clr cociente

div1:
	inc cociente
	sub numeradorL, denominadorL
	sbc numeradorH, denominadorH
	brcc div1
	dec cociente
	
	ret