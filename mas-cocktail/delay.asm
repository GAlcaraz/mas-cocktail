/*
 * delay.asm
 *
 *  Created: 05-Nov-16 5:35:06 PM
 *   Author: galca
 */ 
 .def RETARDO = R21


 retardo10us:
	push RETARDO
	ldi RETARDO,(CRYSTAL/(4*100000)-3)
loop_ret_10:
	dec RETARDO
	NOP
	brne loop_ret_10
	pop RETARDO
	ret

retardo1ms:
	push RETARDO
	ldi RETARDO,98
loop_ret_1m:
	RCALL retardo10us
	dec RETARDO	
	brne loop_ret_1m
	pop RETARDO
	ret

retardo50ms:
	push RETARDO
	ldi RETARDO,50
loop_ret_50m:
	RCALL retardo1ms
	dec RETARDO
	brne loop_ret_50m
	pop RETARDO
	ret

retardo5ms:
	ldi RETARDO,5
loop_ret_5m:
	RCALL retardo1ms
	dec RETARDO
	brne loop_ret_5m
	ret

retardo3s:

	ldi RETARDO, 60
loop_ret_3s:
	RCALL retardo50ms
	dec RETARDO
	brne loop_ret_3s
	ret