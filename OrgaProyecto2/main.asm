# Archivo que contiene toda la logica del juego 

.include "utils.asm"
.data
	matriz:   	.byte 0:250		# La matriz que representa el estado del juego
	
	juego_pausado:	.byte 1			# Indica si el juego esta pausado y por tanto la pelota en su posicion original
	
	posX: 	 	.byte 2			# La posicion de la pelota (x, y), con la posicion original para el jg 1
	posY:	  	.byte 5

	velX:	 	.byte 3			# Velocidad de la pelota, velocidad inicial de forehand
	velY:	   	.byte 3
	
	toco_red:	.byte 0
	num_tc_piso: 	.byte 0
	toque_val_1: 	.byte 0
	toque_val_2:	.byte 0
	
	turno:		.byte 0			# 0: turno del jugador 1, 1: turno del jugador 2
	
	caracter_ant:	.byte 0
	caracter_act:	.byte 115


.text

# Las interrupciones de teclado se activan
encender_inters_tcl

# En s7 vamos a tener nuestro tiempo, lo inicializamos en 0
li $s7, 0

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
	
		# Volvemos O en donde deberia ir la pelota
		lb   $t0, turno
		li   $t1, 79
	
		# Si la pelota esta en la cancha del primer jugador
		turno_j1: bnez $t0, turno_j2
		li   $t0, 127	
		sb   $t1,  matriz($t0)		#guardamos en la posicion calculada el codigo ascii de "0"
		b resto_cancha 
	
		# Si la pelota esta en la cancha del segundo jugador
		turno_j2:
		li   $t0, 147	
		sb   $t1,  matriz($t0)		#guardamos en la posicion calculada el codigo ascii de "0"
		
		# Ponemos el piso y la red
		resto_cancha:
		jal piso_y_red
		
		#Finalmemte imprimimos el estado del juego pausado
		b imprimir_cancha
		
	no_esta_paus:

	# Nueva velocidad
	lb  $t0, velY
	sub $t0, $t0, 1
	sb  $t0, velY
	
	# Se avanza en tiempo 
	add $s7, $s7, 1
	
	# Nueva posicion
	lb  $t0,  velX
	mul $t0, $t0, $s7
	lb  $t1,  posX
	add $t0, $t0, $t1
	sb  $t0, posX
	
	# Revisamos si (x0 < 13 ^ x>=13)V(x0 > 13 ^ x <= 13) para resetear el contador de veces que se toco el piso
	li  $t2, 13
	
	slt $t3, $t1, $t2  # x0 < 13
	sge $t4, $t0, $t2  # x>=13
	and $t3,  $t3, $t4 # (x0 < 13 ^ x>=13)
	
	sgt $t4, $t1, $t2 # x0 > 13
	sle $t5, $t0, $t2 # x <= 13
	and $t4, $t4, $t5 # (x0 > 13 ^ x <= 13)
	
	or $t3, $t3, $t4  #(x0 < 13 ^ x>=13)V(x0 > 13 ^ x <= 13)
	
	actualizar_tc_piso: beqz $t3, no_actualizar_tc_piso
	li $t2, 0
	sb $t2, num_tc_piso
	
	no_actualizar_tc_piso:
	
	# Procedemos a revisa si posX > 24 V posX < 0
	li  $t1, 0
	slt $t1, $t0, $t1
	
	li  $t2, 24 	
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
		 	
		 	# Volvemos cero nuestras variables indicadoras
		 	sb $t2, toco_red
		 	sb $t2, num_tc_piso
		 	sb $t2, toque_val_1
		 	sb $t2, toque_val_2
		 	
		 	# volvemos a poner el tiempo en 0
		 	li $s7, 0
		
		b juego_loop
		
		
	no_ocu_fuera:
	
	lb  $t0,  velY
	mul $t0, $t0, $s7
	lb  $t1,  posY
	sub $t0, $t1, $t0
	sb  $t0, posY
	
	li   $t1, 24
	sgt  $t0, $t0, $t1 
	
	#Revisamos si la pelota tocó el piso, si no fue asi ent toca calcular la nueva matriz
	tc_piso: beqz $t0, calc_nv_matriz		
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
	
	# Se revisa que y no sea menor que 0 (el techo de nuestra pantalla)
	
	lb $t0, posY
	li $t1, 0
	# si y excede la pantalla, entonces no posicionamos la pelota en este frame y simplemente calculamos el resto de elementos
	blt $t0, $t1, resto_de_la_cancha
		
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
		apagar_inters_tcl
		
		# Generamos una interrupcion para imprimir la cancha de la consola 
		li   $t1, 0
		teqi $t1, 0
		
		#Reactivamos las excepciones de teclado:
		encender_inters_tcl
	
	# Calculamos el tiempo que llevo el refrescamiento 
	li  $v0, 30
	syscall #time
	sub $s6,  $s6,$a1 #tiempo transcurrido
	
	li  $t7, 200
	sub $a0, $t7,$s6 #tiempo restante
	li  $v0, 32
	
	syscall #sleep
				
b juego_loop

######################  FUNCIONES  ######################

# Funcion  que revisa si hubo un nuevo input y modifica las variables en caso de que sea un input valido
# No recibe nada, no devuelve nada
revisar_input:
	#Apagamos las interrupciones de teclado:
	apagar_inters_tcl
	
	lb $t0, caracter_act
	input_jugador1: bne $t0, 100, input_jugador2	# Si el caracter nuevo no es 'd', podria ser 'l'
		
	# Revisamos si se cumple toque_val_1
	lb   $t0, toque_val_1
	bnez $t0, fin_revisar_input
	
	#Revisamos que el caracter anterior pertenezca a {x, s, w}
	lb  $t0, caracter_ant		
	seq $t4, $t0, 120 #x
	seq $t5, $t0, 115 #s
	seq $t6, $t0, 119 #w
	
	or  $t4, $t4, $t5
	or  $t4, $t4, $t6
	
	beqz $t4, fin_revisar_input
	
	# Revisamos si (x < 13)
	lb  $t1, posX
	li  $t2, 13
	bge $t1, $t2, fin_revisar_input
	
	# Revisamos si la pelota toco la red, en ese caso no hacemos nada
	lb   $t0, toco_red
	bnez $t0, fin_revisar_input
	
	# Revisamos si se ha tocado el piso mas de dos veces en la mitad correspond
	lb   $t0, num_tc_piso
	bge  $t0, 2, fin_revisar_input
	
	# Si llegamos hasta aca es porque es un toque valido y procedemos a efectuarlo
	li $t0, 1
	sb $t0, toque_val_1
	li $t0, 0
	sb $t0, toque_val_2
	
	lb   $t0, juego_pausado
	beqz $t0, seleccionar_modo 
	li   $t0, 0
	sb   $t0, juego_pausado
	
	seleccionar_modo:
	
	lb   $t0, caracter_ant
	
	beq  $t0, 120, Underhand #x
	beq  $t0, 115, Forehand  #s
	beq  $t0, 119, Backhand  #w
	
	# aplicar Underhand
	Underhand:
		lb $t0, velX
		lb $t1, velY
		
		li  $t2, -1
		mul $t0, $t0, $t2 # Cmbiamos el signo de x
		mul $t1, $t1, $t2 # Cmbiamos el signo de y
		
		sb $t1, velX # Guardamos la vel de y en la de x
		sb $t0, velY # Guardamos la vel de x en la de y
		
	b fin_revisar_input
	
	# aplicar Forehand
	Forehand:
		lb $t0, velX
		lb $t1, velY
		
		add $t2, $t0, $t1
		div $t2, $t2, 2
		
		lbu $t3, velX
		lbu $t4, velY
		
		div $t3, $t0, $t3   # Calculamos el signo de la vel en x
		div $t4, $t1, $t4   # Calculamos el signo de la vel en y 
		
		mul $t3, $t2, $t3
		mul $t4, $t2, $t4
		
		sb  $t3, velX
		sb  $t3, velY
	
	b fin_revisar_input
	
	# aplicar Backhand
	Backhand:
		lb  $t0, velX
		mul $t0, $t0, -1
		sw  $t0, velX
	
	b fin_revisar_input
	
	input_jugador2: bne $t0, 108, fin_revisar_input  # Si el nuevo caracter no era 'l' entonces no hay nada que revisar
	
	# Revisamos si se cumple toque_val_2
	lb   $t0, toque_val_2
	bnez $t0, fin_revisar_input
	
	#Revisamos que el caracter anterior pertenezca a {o,k, m}
	lb  $t4, caracter_ant		
	seq $t5, $t4, 111 #o
	seq $t6, $t4, 107 #k
	seq $t7, $t4, 109 #m
	
	or $t5, $t5, $t6
	or $t5, $t5, $t7
	
	beqz $t5, fin_revisar_input
	
	# revisamos si (x >13)
	lb  $t1, posX
	li  $t2, 13
	ble $t1, $t2, fin_revisar_input
	
	# Revisamos si la pelota toco la red, en ese caso no hacemos nada
	lb   $t0, toco_red
	bnez $t0, fin_revisar_input
	
	# Revisamos si se ha tocado el piso mas de dos veces en la mitad correspond
	lb   $t0, num_tc_piso
	bge  $t0, 2, fin_revisar_input
	
	# Si llegamos hasta aca es porque es un toque valido y procedemos a efectuarlo
	li $t0, 0
	sb $t0, toque_val_1
	li $t0, 1
	sb $t0, toque_val_2
	
	lb   $t0, juego_pausado
	beqz $t0, seleccionar_modo2
	li   $t0, 0
	sb   $t0, juego_pausado
	
	seleccionar_modo2:
	
	lb   $t0, caracter_ant
	
	beq  $t0, 111, Underhand2 #o
	beq  $t0, 107, Forehand2  #k
	beq  $t0, 109, Backhand2  #m
	
	# aplicar Underhand
	Underhand2:
		lb $t0, velX
		lb $t1, velY
		
		li  $t2, -1
		mul $t0, $t0, $t2 # Cmbiamos el signo de x
		mul $t1, $t1, $t2 # Cmbiamos el signo de y
		
		sb $t1, velX # Guardamos la vel de y en la de x
		sb $t0, velY # Guardamos la vel de x en la de y
		
	b fin_revisar_input
	
	# aplicar Forehand
	Forehand2:
		lb $t0, velX
		lb $t1, velY
		
		add $t2, $t0, $t1
		div $t2, $t2, 2
		
		lbu $t3, velX
		lbu $t4, velY
		
		div $t3, $t0, $t3   # Calculamos el signo de la vel en x
		div $t4, $t1, $t4   # Calculamos el signo de la vel en y 
		
		mul $t3, $t2, $t3
		mul $t4, $t2, $t4
		
		sb  $t3, velX
		sb  $t3, velY
	
	b fin_revisar_input
	
	# aplicar Backhand
	Backhand2:
		lb  $t0, velX
		mul $t0, $t0, -1
		sb  $t0, velX
	
	b fin_revisar_input

fin_revisar_input:
	#Reactivamos las excepciones de teclado:
	encender_inters_tcl
	jr $ra
	

# Funcion que modifica la matriz de estado para guardar la posicion del piso y la red
# no recibe nada, no devuelve nada
piso_y_red:
	li   $t1, 79
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
	
	piso_loop: beqz $t2, fin_piso_y_red
	
	sb   $t1, matriz($t0)
	addi $t0, $t0, 1
	sub  $t2, $t2, 1 
	
	b piso_loop
	
fin_piso_y_red:
	jr $ra

######################  MANEJADOR DE INTERRUPCIONES Y EXCEPCIONES  ######################
# SPIM S20 MIPS simulator.
# The default exception handler for spim.
#
# Copyright (C) 1990-2004 James Larus, larus@cs.wisc.edu.
# ALL RIGHTS RESERVED.
#
# SPIM is distributed under the following conditions:
#
# You may make copies of SPIM for your own use and modify those copies.
#
# All copies of SPIM must retain my name and copyright notice.
#
# You may not sell SPIM or distributed SPIM in conjunction with a commerical
# product or service without the expressed written consent of James Larus.
#
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE.
#

# $Header: $


# Define the exception handling code.  This must go first!

	.kdata
__m1_:	.asciiz "  Exception "
__m2_:	.asciiz " occurred and ignored\n"
__e0_:	.asciiz "  [Interrupt] "
__e1_:	.asciiz	"  [TLB]"
__e2_:	.asciiz	"  [TLB]"
__e3_:	.asciiz	"  [TLB]"
__e4_:	.asciiz	"  [Address error in inst/data fetch] "
__e5_:	.asciiz	"  [Address error in store] "
__e6_:	.asciiz	"  [Bad instruction address] "
__e7_:	.asciiz	"  [Bad data address] "
__e8_:	.asciiz	"  [Error in syscall] "
__e9_:	.asciiz	"  [Breakpoint] "
__e10_:	.asciiz	"  [Reserved instruction] "
__e11_:	.asciiz	""
__e12_:	.asciiz	"  [Arithmetic overflow] "
__e13_:	.asciiz	"  [Trap] "
__e14_:	.asciiz	""
__e15_:	.asciiz	"  [Floating point] "
__e16_:	.asciiz	""
__e17_:	.asciiz	""
__e18_:	.asciiz	"  [Coproc 2]"
__e19_:	.asciiz	""
__e20_:	.asciiz	""
__e21_:	.asciiz	""
__e22_:	.asciiz	"  [MDMX]"
__e23_:	.asciiz	"  [Watch]"
__e24_:	.asciiz	"  [Machine check]"
__e25_:	.asciiz	""
__e26_:	.asciiz	""
__e27_:	.asciiz	""
__e28_:	.asciiz	""
__e29_:	.asciiz	""
__e30_:	.asciiz	"  [Cache]"
__e31_:	.asciiz	""
__excp:	.word __e0_, __e1_, __e2_, __e3_, __e4_, __e5_, __e6_, __e7_, __e8_, __e9_
	.word __e10_, __e11_, __e12_, __e13_, __e14_, __e15_, __e16_, __e17_, __e18_,
	.word __e19_, __e20_, __e21_, __e22_, __e23_, __e24_, __e25_, __e26_, __e27_,
	.word __e28_, __e29_, __e30_, __e31_
s1:	.word 0
s2:	.word 0

.ktext	0x80000180
	
	# Select the appropriate one for the mode in which SPIM is compiled.
	.set noat
	move $k1 $at		# Save $at
	.set at
	sw $v0 s1		# Not re-entrent and we can't trust $sp
	sw $a0 s2		# But, we need to use these registers

	mfc0 $k0 $13		# Cause register
	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0xf

	# Print information about exception.
	#
	li $v0 4		# syscall 4 (print_str)
	la $a0 __m1_
	syscall

	li $v0 1		# syscall 1 (print_int)
	srl $a0 $k0 2		# Extract ExcCode Field
	andi $a0 $a0 0xf
	syscall

	li $v0 4		# syscall 4 (print_str)
	andi $a0 $k0 0x3c
	lw $a0 __excp($a0)
	nop
	syscall

	bne $k0 0x18 ok_pc	# Bad PC exception requires special checks
	nop

	mfc0 $a0 $14		# EPC
	andi $a0 $a0 0x3	# Is EPC word-aligned?
	beq $a0 0 ok_pc
	nop

	li $v0 10		# Exit on really bad PC
	syscall

ok_pc:
	
	# Hay que revisar que la interrupcion no haya sido por teclado
	mfc0  $k1, $13
	andi  $k1,  0x0000100 #mask
	beqz  $k1,  no_fue_int_tlc
	
	#Apagamos las interrupciones de teclado 
	apagar_inters_tcl
	
	# Si lo fue procedemos a guardar lo que nos hayan pasado
	
	lb $k1, caracter_act			#primero guardamos el ulitmo caracter guardado en caracter_ant
	sb $k1, caracter_ant

	lw $k1, 0xffff0004			# Obtenemos lo pasado por teclado
	sb $k1, caracter_act			# Lo guardamos como caracter actual
	
	#Reactivamos las excepciones de teclado:
	encender_inters_tcl
	
	b volver_al_programa
	
	no_fue_int_tlc:
	# NO fue por teclado. Asumimos que fue para imprimir
	
	li  $t0, 12 # Vamos a formatear la consola
	sw  $t0,  0xffff000c  
	jal waitPrint
	
	li $s0, 250
	la $s1, matriz
	li $s2, 0
	
	loop_print: beqz $s0, end_print
		lb $s3, ($s1)

		if: bnez $s3, else
		li  $t0, 32 
		li $t1, 0xffff000c  
		sb  $t0, ($t1)  
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
	
	

# Volvemos al programa
volver_al_programa:


ret:
# Return from (non-interrupt) exception. Skip offending instruction
# at EPC to avoid infinite loop.
#
	mfc0 $k0 $14		# Bump EPC register
	addiu $k0 $k0 4		# Skip faulting instruction
				# (Need to handle delayed branch case here)
	mtc0 $k0 $14


# Restore registers and reset procesor state
#
	.set noat
	move $at $k1		# Restore $at
	.set at
	lw $v0 s1		# Restore other registers
	lw $a0 s2

	mtc0 $0 $13		# Clear Cause register

	mfc0 $k0 $12		# Set Status register
	ori  $k0 0x1		# Interrupts enabled
	mtc0 $k0 $12

# Return from exception on MIPS32:
	eret