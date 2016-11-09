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

DisplayMenu0:
	
	LDi ZH, High(2*T_Mode_Select)
	LDI ZL, LOW(2*T_Mode_Select)
	
	RCALL DisplayString
	
		
	ret

DisplayMenu1a:
	
	LDi ZH, High(2*T_Pred_Select)
	LDI ZL, LOW(2*T_Pred_Select)
	
	RCALL DisplayString
	
		
	ret

DisplayMenu2a:
	
	LDi ZH, High(2*T_Pot_Select)
	LDI ZL, LOW(2*T_Pot_Select)
	
	RCALL DisplayString
	
		
	ret

DisplayMenu1b:
	
	LDi ZH, High(2*T_Bebida1_Select)
	LDI ZL, LOW(2*T_Bebida1_Select)
	
	RCALL DisplayString
	
		
	ret

DisplayMenu2b:
	
	LDi ZH, High(2*T_Porc_Select)
	LDI ZL, LOW(2*T_Porc_Select)
	
	RCALL DisplayString
	
		
	ret

DisplayMenu3b:
	
	LDi ZH, High(2*T_Bebida2_Select)
	LDI ZL, LOW(2*T_Bebida2_Select)
	
	RCALL DisplayString
	
		
	ret

 ;....................TABLAS (display)...........................

T_Welcome:
	.Db 'B','I','E','N','V','E','N','I','D','O','S','!','!',0

T_COCKTail:
	.DB '*','*','*','C','O','C','K','-','T','A','I','L','*','*','*',0
	
T_Mode_Select:
	.DB		"Seleccione modo de operación:\n1-Predeterminado\t2-Precisión ",0 

T_Pred_Select:
	.DB		"Seleccione bebida:\n1-Fernet\t2-Whiscola\t3-Coca-Cola",0

T_Pot_Select:
	.DB		"Seleccione potencia:\n1-Fuerte\t2-Media\t3-Me la como",0

T_Bebida1_Select:
	.DB		"Seleccione primera bebida:\n1-Fernet\t2-Whisky\t3-Coca ",0

T_Bebida2_Select:
	.DB		"Seleccione segunda bebida:\n1-Fernet\t2-Whisky\t3-Coca ",0

T_Porc_Select:
	.DB		"Introduzca porcentaje: ",0