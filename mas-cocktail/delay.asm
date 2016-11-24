/*
 * delay.asm
 *
 *  Created: 05-Nov-16 5:35:06 PM
 *   Author: galca
 */ 
 retardo10us:
	push TEMP
	ldi TEMP,58
loop_ret_10:
	dec TEMP
	NOP
	brne loop_ret_10
	pop TEMP
	ret

retardo1ms:
	push TEMP
	ldi TEMP,100
loop_ret_1m:
	RCALL retardo10us
	dec TEMP	
	brne loop_ret_1m
	pop TEMP
	ret

retardo50ms:
	push TEMP
	ldi TEMP,50
loop_ret_50m:
	RCALL retardo1ms
	dec TEMP
	brne loop_ret_50m
	pop TEMP
	ret

retardo500ms:
	push TEMP
	ldi TEMP,10
loop_ret_500m:
	RCALL retardo50ms
	dec TEMP
	brne loop_ret_500m
	pop TEMP
	ret

retardo5ms:
	ldi TEMP,5
loop_ret_5m:
	RCALL retardo1ms
	dec TEMP
	brne loop_ret_5m
	ret

retardo3s:

	ldi TEMP, 60
loop_ret_3s:
	RCALL retardo50ms
	dec TEMP
	brne loop_ret_3s
	ret

retardo1s:

	ldi TEMP, 20
loop_ret_1s:
	RCALL retardo50ms
	dec TEMP
	brne loop_ret_1s
	ret