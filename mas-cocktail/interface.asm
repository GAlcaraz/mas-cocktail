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
	RCALL DisplayEnter
	
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

DisplayWait:
	
	LDi ZH, High(2*T_Espere)
	LDI ZL, LOW(2*T_Espere)

	RCALL DisplayString
	ret

DisplayDone:
	
	LDi ZH, High(2*T_Listo)
	LDI ZL, LOW(2*T_Listo)

	RCALL DisplayString
	ret

 ;....................TABLAS (display)...........................

T_Welcome:
	.Db 'B','I','E','N','V','E','N','I','D','O','S','!',0,0

T_COCKTail:
	.DB '*','*','*','C','O','C','K','-','T','A','I','L','*','*',0,0
	
T_Mode_Select:
	.DB		"Seleccione modo de operacion:",0,"1-Basico 2-Avanzado",0,0 

T_Pred_Select:
	.DB		"Seleccione bebida:",0,"1-Fernet 2-Whiscola 3-Coca-Cola",0,0

T_Pot_Select:
	.DB		"Seleccione potencia:",0,"1-Cordobes 2-Media 3-Infantil",0,0

T_Bebida1_Select:
	.DB		"Seleccione primera bebida:",0,"1-Fernet 2-Whisky 3-Coca",0,0

T_Bebida2_Select:
	.DB		"Seleccione segunda bebida:",0," 1-Fernet 2-Whisky 3-Coca ",0,0

T_Porc_Select:
	.DB		"Introduzca",0,"porcentaje: ",0,0

T_Espere:
	.DB		"Espere ",0,"por favor...",0,0

T_Listo:
	.DB		"Listo! Retire su",0,"bebida por favor",0,0