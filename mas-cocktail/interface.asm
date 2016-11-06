/*
 * interface.asm
 *
 *  Created: 05-Nov-16 7:59:54 PM
 *   Author: galca
 */ 







 ;....................Display welcome............................
DisplayWelcome:
	
	LDi ZH, High(2*T_Welcome)
	LDI ZL, LOW(2*T_Welcome)
	
	RCALL DisplayString
	
	LDI ZH, High(2*T_Cocktail)
	LDI ZL, LOW(2*T_Cocktail)
	
	RCALL DisplayString
		
	ret

 ;....................TABLAS (display)...........................

T_Welcome:
	.Db 'B','I','E','N','V','E','N','I','D','O','S','!','!',0

T_COCKTail:
	.DB '*','*','*','C','O','C','K','-','T','A','I','L','*','*','*',0
	
T_Mode_Select:
	.DB		"Seleccione modo de operación:\n1-Predeterminado\t2-Precisión ",0 
