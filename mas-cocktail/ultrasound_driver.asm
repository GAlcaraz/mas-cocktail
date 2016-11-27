/*
 * ultrasound_driver.asm
 *
 *  Created: 19-Nov-16 4:18:04 PM
 *   Author: galca
 */ 

.EQU USART_BAUDRATE = 9600
.EQU BAUD_PRESCALE = (((F_CPU / (USART_BAUDRATE * 16))) - 1)

InitUsart:
		LDI		TEMP,(1<<TXEN0)|(1<<RXEN0)
		STS		UCSR0B,TEMP
		LDI		TEMP,(3<<UCSZ00)
		STS		UCSR0C,R16
		LDI		TEMP,0X77
		STS		UBRR0L,TEMP
		LDI		TEMP,0x00
		STS		UBRR0H,TEMP

		RET

measurement:
		POP		ZH
		POP		ZL

		LDI		TEMP,0x55
		RCALL	transmit
		RCALL	retardo50ms
		RCALL	receive
		PUSH	TEMP
		RCALL	receive
		PUSH	TEMP
		/*RCALL receive*/

		PUSH	ZL
		PUSH	ZH
		RET


transmit:		
		LDS		TEMP2,UCSR0A
		SBRS	TEMP2,UDRE0
		RJMP	transmit
		STS		UDR0,TEMP
		RET

receive:
		LDS		TEMP2,UCSR0A
		SBRS	TEMP2,UDRE0
		RJMP	receive
		LDS		TEMP,UDR0
		RET