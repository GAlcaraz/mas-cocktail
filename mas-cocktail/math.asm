/*
 * math.asm
 *
 *  Created: 18-Nov-16 11:18:15 AM
 *   Author: galca
 */ 

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
