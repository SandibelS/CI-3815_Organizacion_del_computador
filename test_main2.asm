# Archivo que contiene toda la logica del juego 

.include "utils.asm"
.data
	matriz:   	.byte 0:250		# La matriz que representa el estado del juego
	
	.word -1 # Usado para poder ver la correcta actualizacion de los datos. HAY QUE BORRAR
	
	juego_pausado:	.byte 0			# Indica si el juego esta pausado y por tanto la pelota en su posicion original
	
	.space 3 # HAY QUE BORRAR
	
	posX: 	 	.byte 2			# La posicion de la pelota (x, y), con la posicion original para el jg 1
	
	.space 3 # HAY QUE BORRAR
	
	posY:	  	.byte 5
	
	.space 3 #HAY QUE BORRAR
	
	velX:	 	.byte 3			# Velocidad de la pelota, velocidad inicial de forehand
	
	.space 3 #HAY QUE BORRAR
	
	velY:	   	.byte 3
	
	.space 3 #HAY QUE BORRAR
	
	# No se si esta variable es necesaria al final 
	modo: 		.byte 1			# Modo de juego, 0: Underhand, 1: forehand, 2: backhand
	
	# velocidades iniciales ???????
	
	toco_red:	.byte 0
	num_tc_piso: 	.byte 0
	toque_val_1: 	.byte 0
	toque_val_2:	.byte 0
	
	# Tampoco se si esta variable sea necesaria al final 
	turno:		.byte 0			# 0: turno del jugador 1, 1: turno del jugador 2
	
	.word -2 #HAY QUE BORRAR
	
	caracter_ant:	.byte 0
	
	.space 3 #HAY QUE BORRAR
	
	caracter_act:	.byte 0


.text

# Las interrupciones de teclado se activan
encender_inters_tcl
