
.include "utils.asm"

.data
	matriz:   	.byte 0:250		# La matriz que representa el estado del juego
	
	###################
	.word -1
	juego_pausado:	.byte 0			# Indica si el juego esta pausado y por tanto la pelota en su posicion original
	.space 3
	posX: 	 	.byte 2			# La posicion de la pelota (x, y), con la posicion original para el jg 1
	.space 3
	posY:	  	.byte 5
	.space 3
	velX:	 	.byte 3			# Velocidad de la pelota, velocidad inicial de forehand
	.space 3
	velY:	   	.byte 3
	.space 3
	
	modo: 		.byte 1			# Modo de juego, 0: Underhand, 1: forehand, 2: backhand
	
	# velocidades iniciales ???????
	
	#vector_inv:	.byte 0 		# se toco red, toque valido 1, toque valido 2, cant de veces que toco piso
	
	toco_red:	.byte 0
	num_tc_piso: 	.byte 0
	toque_val_1: 	.byte 0
	toque_val_2:	.byte 0
	
	turno:		.byte 0			# 0: turno del jugador 1, 1: turno del jugador 2
	
	.word -2 
	caracter_ant:	.byte 0
	.space 3
	caracter_act:	.byte 0


# Las interrupciones de teclado estan activas 
.data 0xffff0000
	.word 2

#### Codigo del programa ###
.text

lb $s7, tiempo

# Se usa un loop para ir imprimiendo el estado del juego 
juego_loop: 
	
	# Obtenemos el tiempo para poder hacer correctamente el refrescamiento
	li $v0,30
	syscall #time
	move $s6,$a1

	jal revisar_input 	# Revisamos en cada ciclo si nos han dado un input valido

	# Si el juego esta pausado simplemente calculamos como deberia verse la cancha con la pelota en la cancha correspondiente
	lb $t0, juego_pausado
	esta_paus: beqz $t0, no_esta_paus
		jal cancha_pausada
		# apagar interupciones de teclado???
		b imprimir_cancha
		done

	no_esta_paus:
	
	# Nueva velocidad
	lb  $t0, velY
	sub $t0, $t0, 1
	sb  $t0, velY
	
	# Se avanza en tiempo 
	add $s7, $s7, 1
	
	# Nueva poscion
	lb  $t0,  velX
	mul $t0, $t0, $s7
	lb  $t1,  posX
	add $t0, $t0, $t1
	sb  $t0, posX
	
	# Revisamos si (x0 < 13 ^ x>=13)V(x0 > 13 ^ x <= 13) para resetear el contador de veces que se toco el piso
	li  $t2, 13
	
	slt $t3, $t1, $t2 # x0 < 13
	sge $t4, $t0, $t2 # x>=13
	and $t3,  $t3, $t4 # (x0 < 13 ^ x>=13)
	
	sgt $t4, $t1, $t2 # x0 > 13
	sle $t5, $t0, $t2 # x <= 13
	and $t4, $t4, $t5 # (x0 > 13 ^ x <= 13)
	
	or $t3, $t3, $t4	#(x0 < 13 ^ x>=13)V(x0 > 13 ^ x <= 13)
	
	actualizar_tc_piso: beqz $t3, no_actualizar_tc_piso
	li $t2, 0
	sb $t2, num_tc_piso
	
	no_actualizar_tc_piso:
	
	
	# en t0 la nueva posdeX
	# Procedemos a revisa si posX > 25 V posX < 0
	li  $t1, 0
	slt $t1, $t0, $t1
	
	li  $t2, 24 	#creo que debria ser 24 
	sgt $t2, $t0, $t2
	
	or  $t1, $t1, $t2
	
	# SI t1 es 1, entonces la pelota se salio de la cancha y hay que volver a pausar el juego 
	ocu_fuera: beqz $t1, no_ocu_fuera
		# Pausamos el juego
		li $t1, 1
		sb $t1, juego_pausado
		
		lb $t1, turno
		
		# Se cambia al lado del otro jugador
		de_1_a_2: bnez $t1, de_2_a_1
			li $t2, 1
			sb $t2, turno
			
			# Actualizamos la posicion de la pelota
			li $t2, 22
			sb $t2, posX
			
			li $t2, 5
			sb $t2, posY
			
			b fin_cambio_jugador
		
		de_2_a_1: 
			li $t2, 0
			sb $t2, turno
			
			# Actualizamos la posicion de la pelota
			li $t2, 2
			sb $t2, posX
			
			li $t2, 5
			sb $t2, posY
			
			
		
		fin_cambio_jugador:
		
			# Fijamos la velocidad inicial
			li $t2, 3
			sb $t2, velX
			sb $t2, velY
			
		 	# Cambiamos al modo forehand
		 	li $t2, 1
		 	sb $t2, modo
		 	
		 	# Volvemos cero nuestras variables indicadoras
		 	sb $t2, toco_red
		 	sb $t2, num_tc_piso
		 	sb $t2, toque_val_1
		 	sb $t2, toque_val_2:
		 	
		 	# volvemos a poner el tiempo en 0
		 	li $s7, 0
		
			
		
		#done ######################
		
		b juego_loop
		
		
	no_ocu_fuera:
	
	lb  $t0,  velY
	mul $t0, $t0, $s7
	lb  $t1,  posY
	#add $t0, $t0, $t1
	sub  $t0, $t1, $t0
	sb  $t0, posY
	
	#li  $t1, 0
	#slt $t0, $t0, $t1
	li   $t1, 24
	sgt  $t0, $t0, $t1 
	
	tc_piso: beqz $t0, calc_nv_matriz		#Revisamos si la pelota toco el piso, si no toco piso toca calcular la nueva matriz
		# Cambiamos el signo de la velocidad en Y
		lb  $t0, velY
		li  $t1, -1
		mul $t0, $t0, $t1
		sb  $t0, velY
		
		# Aumentamos el contador de veces que se ha tocado el piso
		lb   $t0, num_tc_piso
		addi $t0, $t0, 1
		sb   $t0, num_tc_piso 
	
	calc_nv_matriz: 
	
	# Tengo que revisar que y no haya pasado de  0! porque ese es mi techo
	
	lb $t0, posY
	li $t1, 0
	blt $t0, $t1, resto_de_la_cancha	# si y excede la pantalla, entonces no posicionamos la pelota en este frame
	
	lb  $t0, posY
	li  $t1, 25
	mul $t0, $t0, $t1
	lb  $t1, posX
	add $t0, $t0, $t1 
	li  $t1, 79
	sb  $t1, matriz($t0) 			#Posicionamos la pelota
	
	resto_de_la_cancha:
	
	jal piso_y_red				# Volvemos a poner el piso y la red
						# y ya estariamos listos para imprimir
	
	imprimir_cancha:
		#Apagamos las interrupciones de teclado mientras se imprime:
		lw   $s0, 0xffff0000
		andi $s0, $s0, 1
		sw   $s0, 0xffff0000
		
		# Generamos una interrupcion para imprimir la cancha de la consola 
		li   $t1, 0
		teqi $t1, 0
		
		#Reactivamos las excepciones de teclado:
		lw  $s0, 0xffff0000
		ori $s0, $s0, 2
		sw  $s0, 0xffff0000
	
	# Calculamos el tiempo que llevo el refrescamiento 
	li $v0,30
	syscall #time
	sub $s6,$s6,$a1 #tiempo transcurrido
	
	#li $t7,200
	li $t7, 400
	sub $a0,$t7,$s6 #tiempo restante
	li $v0, 32
	
	syscall #sleep
				
b juego_loop


cancha_pausada:

	# Volvemos O en donde deberia ir la pelota
	lb   $t0, turno
	li   $t1, 79
	
	turno_j1: bnez $t0, turno_j2
	li   $t0, 127	
	sb   $t1,  matriz($t0)		#guardamos en la posicion calculada el codigo ascxii de "0"
	b red 
	
	turno_j2:
	li   $t0, 147	
	sb   $t1,  matriz($t0)		#guardamos en la posicion calculada el codigo ascxii de "0"
	
	red:
	li $t0, 162
	sb $t1, matriz($t0)
	
	addi $t0, $t0, 25
	sb $t1, matriz($t0)
	
	addi $t0, $t0, 25
	sb $t1, matriz($t0)	
	
	piso:
	li $t0, 225
	li $t2, 25
	
	piso_loop: beqz $t2, fin_cancha_pausada
	
	sb   $t1, matriz($t0)
	addi $t0, $t0, 1
	sub  $t2, $t2, 1 
	
	b piso_loop
	
fin_cancha_pausada:
	jr $ra

piso_y_red:
	li   $t1, 79
	red2:
	li $t0, 162
	sb $t1, matriz($t0)
	
	addi $t0, $t0, 25
	sb $t1, matriz($t0)
	
	addi $t0, $t0, 25
	sb $t1, matriz($t0)	
	
	piso2:
	li $t0, 225
	li $t2, 25
	
	piso_loop2: beqz $t2, fin_piso_y_red
	
	sb   $t1, matriz($t0)
	addi $t0, $t0, 1
	sub  $t2, $t2, 1 
	
	b piso_loop2
	
fin_piso_y_red:
	jr $ra

revisar_input:

	#Apagamos las interrupciones de teclado:
		lw   $s0, 0xffff0000
		andi $s0, $s0, 1
		sw   $s0, 0xffff0000
	
	
	# Revisamos si la pelota toco la red, en ese caso no hacemos nada
	lb   $t0, toco_red
	bnez $t0, fin_revisar_input
	
	# Revisamos si se ha tocado el piso mas de dos veces en la mitad correspond
	lb   $t0, num_tc_piso
	bge  $t0, 2, fin_revisar_input
	
	# Revisamos si se cumple D^toque_val_1 V L^toque_val_2, en ese caso no hacemos nada
	
	
	
	
	
	# Revisamos si se cumple D^(x<13) V L^(x >13), si no es asi, no hacemos nada
	lb  $t0, caracter_act
	lb  $t1, posX
	
	seq $t2, $t0, 100	# revisamos si el caracter es d
	slt $t3, $t1, 13
	and $t2, $t2, $t3 	# D^(x<13)
	
	lb  $t3, caracter_ant		#Revisamos que el caracter anterior pertenezca a {x, s, w}
	seq $t4, $t3, 120 #x
	seq $t5, $t3, 115 #s
	seq $t6, $t3, 119 #w
	
	or $t4, $t4, $t5
	or $t4, $t4, $t6
	
	and $t2, $t2, $t4 	# D^(x<13)^caracter_ant e {x, s, w}
	
	
	seq $t3, $t0, 108	# revisamos si el caracter es l
	sgt $t4, $t1, 13	# 
	and $t3, $t3, $t4 	# L^(x >13)
	
	lb  $t4, caracter_ant		#Revisamos que el caracter anterior pertenezca a {o,k, m}
	seq $t5, $t4, 111 #o
	seq $t6, $t4, 107 #k
	seq $t7, $t4, 109 #m
	
	or $t5, $t5, $t6
	or $t5, $t5, $t7
	
	and $t3, $t3, $t5 	# L^(x >13)^caracter_ant e {o,k, m}
	
	or $t2, $t2, $t3 	# D^(x<13) V L^(x >13)
	
	beqz $t2, fin_revisar_input
	
	# Si llegamos hasta aca, entonces se hizo un toque valido.
	
	# cambiamos el modo?
	# cargar el caracter anterior
	# aplicar Underhand
	# aplicar Forehand
	# aplicar Backhand
	
	


fin_revisar_input:
	#Reactivamos las excepciones de teclado:
		lw  $s0, 0xffff0000
		ori $s0, $s0, 2
		sw  $s0, 0xffff0000
	jr $ra

### Codigo para el manejador de interrupciones y excepciones ###
.ktext	0x80000180
	push ($s0)
	push ($s1)
	push ($s2)
	push ($s3)
	

	
	# Hay que revisar que la interrupcion no haya sido por teclado
	mfc0  $k1, $13
	andi  $k1,  0x0000100 #mask
	beqz  $k1,  no_fue_int_tlc
	
	#Apagamos las interrupciones de teclado 
	lw   $s0, 0xffff0000
	andi $s0, $s0, 1
	sw   $s0, 0xffff0000
	
	# Si lo fue procedemos a guardar lo que nos hayan pasado
	
	lb $k1, caracter_act			#primero guardamos el ulitmo caracter guardado en caracter_ant
	sw $k1, caracter_ant

	lw $k1, 0xffff0004			# Obtenemos lo pasado por teclado
	sw $k1, caracter_act			# Lo guardamos como caracter actual
	
	#Reactivamos las excepciones de teclado:
	lw  $s0, 0xffff0000
	ori $s0, $s0, 2
	sw  $s0, 0xffff0000
	
	b volver_al_programa
	
	no_fue_int_tlc:
	# NO fue por teclado. Asumimos que fue para imprimir
	
	li $s0, 250
	la $s1, matriz
	#li $s2, 46 #46 es un punto para ver que esta trabajando bien, deberia ser 32 que es un espacio
	li $s2, 0
	
	loop_print: beqz $s0, end_print
		lb $s3, ($s1)

		if: bnez $s3, else
		li  $t0, 46
		sw  $t0,  0xffff000c  
		#sw  $s2,  0xffff000c  
		jal waitPrint
		b salto

		else: bne $s3, 79, salto
		sw  $s3,  0xffff000c
		jal waitPrint
		
		salto: bne $s2, 24, endif
		li  $t0, 10
		sw  $t0,  0xffff000c  
		jal waitPrint
		li $s2, -1

		endif:
		# Limpiamos la matriz 
		li  $t0, 0
		sb  $t0, ($s1)

		add $s1, $s1, 1
		add $s2, $s2, 1
		sub $s0, $s0, 1
	b loop_print

waitPrint: 	
		lw   $k1, 0xffff0008	#Saber si podemos seguir escribiendo
		andi $k1, 0x00000001
		beqz $k1, waitPrint
		jr   $ra
		
end_print:

	li $s0, 1
	loop_saltos: beqz $s0,fin_loop_saltos
		li  $t1, 10
		sw  $t1,  0xffff000c  
		jal waitPrint
		
		sub $s0, $s0, 1
	b loop_saltos
	
	fin_loop_saltos:

# Volvemos al programa
volver_al_programa:
pop ($s3)
pop ($s2)
pop ($s1)
pop ($s0)


mfc0 $k0, $14
addi $k0, $k0, 4
mtc0 $k0, $14

eret
