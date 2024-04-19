.data
	.include "*.asm"
	
	# Necesitamos espacio para los nodos que seran las cabezas de nuestro dias
	head0: .word  0, 0, 0, 0, 0, 0, 0, 0			# Lunes
	head1: .word  0, 0, 0, 0, 0, 0, 0, 0			# Martes
	head2: .word  0, 0, 0, 0, 0, 0, 0, 0			# Miercoles
	head3: .word  0, 0, 0, 0, 0, 0, 0, 0			# Jueves
	head4: .word  0, 0, 0, 0, 0, 0, 0, 0			# Viernes
	head5: .word  0, 0, 0, 0, 0, 0, 0, 0			# Sabado
	
	# strings necesarios para imprimir
	menu_abajo:	 .asciiz " <- A | D -> | X"
	tiempo_libre:	 .asciiz "Tiempo libre"
	salto: 		 .asciiz "\n"
	teoria: 	 .asciiz "Teoria"
	lab:		 .asciiz "Laboratorio"
	lunes:  	 .asciiz "Lunes"
	martes: 	 .asciiz "Martes"
	miercoles: 	 .asciiz "Miercoles"
	jueves: 	 .asciiz "Jueves"
	viernes: 	 .asciiz "Viernes"
	sabado: 	 .asciiz "Sabado"

.include "utils.asm"
.include "process_data.asm"
.include "longest_name.asm"
.include "first_class.asm"
.include "print_class.asm"

.text

	process_data
	
	longest_name

	add $s5, $s5, 20 		#Calculamos el tamaño de la caja 

	first_class

	move $a1, $s7			# Movemos nuestra direccion del nodo actual
	li   $a2, 0			# Se supone que siempre va a haber al menos una clase

print__:
	print_class

input:
	li $v0, 12			# Esperamos el input del usuario
	syscall

	beq $v0, 120, end		# Si el usuario le da a "x" entonces se termina el programa
	beq $v0, 119, previous_class	# arriba
	beq $v0, 115, next_class	# abajo
	beq $v0, 97,  st_previous_day	# izquierda
	beq $v0, 100, st_next_day	# derecha
	b   input			# Si no se ingreso una de las teclas especificadas

previous_class:

	lw   $t0, ($s7) 
	
	move $a1, $s6
	jal  choose_head  			# Buscamos la cabeza correspondiente
	move $t1, $v1

	bne $t0, $t1, end_previous_class	# Revisamos que la direccion del nodo antrior no apunte a la cabeza
	li $t0, 0
	
	previous_class_loop: bnez $t0, sc_pr_cl
	
	sub  $s6, $s6, 1	# Como debemos movernos al anterior dia restamos en uno y luego le aplicamos mod con 6
	li   $t1, 6		# al resultado para obtener el dia en el rango [0,5]
	add  $s6, $s6, 6
	div  $s6, $t1
	mfhi $s6		
	
	move $a1, $s6
	jal  choose_head  	# Buscamos la cabeza correspondiente
	move $t0, $v1		# Obtenemos nuestra cabeza
	
	lw  $t0, 28($t0)	# Cargamos lo que haya en el campo del nodo siguiente
	
	b previous_class_loop 
	
sc_pr_cl:
	lw $t1, 28($t0)
	sc_pr_cl_loop: beqz $t1, end_previous_class
	
	lw $t0, 28($t0)
	lw $t1, 28($t0)
	
	b sc_pr_cl_loop

end_previous_class:
	move $s7, $t0		# Actualizamos nuestro nodo actual 
	move $a1, $t0
	li   $a2, 0
	b print__
	

next_class:
	lw   $t0, 28($s7) 
	beqz $t0, next_class_loop
	b end_next_class
	
	next_class_loop: bnez $t0, end_next_class
	
	add  $s6, $s6, 1	# Como debemos ,overnos al siguiente dia sumamos en uno y luego le aplicamos mod con 6
	li   $t1, 6		# al resultado para obtener el dia en el rango [0,5]
	div  $s6, $t1
	mfhi $s6		
	
	move $a1, $s6
	jal  choose_head  	# Buscamos la cabeza correspondiente
	move $t0, $v1		# Obtenemos nuestra cabeza
	
	lw  $t0, 28($t0)	# Cargamos lo que haya en el campo del nodo siguiente
	
	b next_class_loop 
	
end_next_class:
	move $s7, $t0		# Actualizamos nuestro nodo actual 
	move $a1, $t0
	li   $a2, 0
	b print__
	
st_previous_day:
	sub  $t0, $s6, 1 		# Primero vamos a revisar que la lista no este vacia, para eso calculamos el numero del dia anterior
	li   $t1, 6	
	add  $t0, $t0, 6	
	div  $s0, $t1
	mfhi $t0
	
	move $a1, $t0
	jal choose_head
	
	lw   $t1, 28($v1)
	
	lw   $a1, 8($s7)
	move $a2, $t0
	bnez $t1, src_sm_hor		# Si la lista no esta vacia, procedemos a buscar la clase en ella
	
					# Si la lista esta vacia, el nodo actual sera el ultimo de nuestra lista actual
	move $t1, $s7
	lw   $t2, 28($s7)
	
	st_next_day_loop: beqz $t2, end_st_next_day_loop	# Procedmos a buscar el ultimo nodo
		move $t1, $t2
		lw   $t2, 28($t1)	
	end_st_next_day_loop:
	
	li   $s4, 1						# Guardamos la señal que nos dice que se imprime una caja de tiempo libre
	move $a1, $t0						# Especificamos en que dia estamos
	lw   $a2, 8($s7)					# Cargamos el horario que habiamos buscado
	move $s7, $t1 						# Actualizamos nuestro nodo actual
	b print__
	
st_next_day:

	add  $t0, $s6, 1 		# Primero vamos a revisar que la lista no este vacia, para eso calculamos el numero del dia sig
	li   $t1, 6		
	div  $s0, $t1
	mfhi $t0
	
	move $a1, $t0
	jal choose_head
	
	lw   $t1, 28($v1)
	
	lw   $a1, 8($s7)
	move $a2, $t0
	bnez $t1, src_sm_hor		# Si la lista no esta vacia, procedemos a buscar la clase en ella
	
					# Si la lista esta vacia, el nodo actual sera el ultimo de nuestra lista actual
	move $t1, $s7
	lw   $t2, 28($s7)
	
	#st_next_day_loop: beqz $t2, end_st_next_day_loop	# Procedmos a buscar el ultimo nodo
		move $t1, $t2
		lw   $t2, 28($t1)	
	#end_st_next_day_loop:
	
	li   $s4, 1						# Guardamos la señal que nos dice que se imprime una caja de tiempo libre
	move $a1, $t0						# Especificamos en que dia estamos
	lw   $a2, 8($s7)					# Cargamos el horario que habiamos buscado
	move $s7, $t1 						# Actualizamos nuestro nodo actual
	b print__

src_sm_hor:
	# Recibe:
	#	$a1 el horario del nodo en que se estaba posicionado y que se busca en el siguiente dia
	#       $a2 el numero del dia en donde buscar
	
	push ($s0)		
	push ($s1)
	push ($s2)
	push ($s3)
	
	move $a1, $a2
	jal  choose_head
	lw   $s0, 28($v1)				# Cargamos la direccion que contenga la cabeza del dia nuevo
	
	move $s3, $a1
	jal calcular_bloque				# Calculamos el bloque horario del nodo en el que estabamos y lo guardamos
	move $s1, $v0					# Vamos a llamar a este horario X-Y
	move $s2, $v1
	
	src_sm_hor_loop: beqz $s0, end_src_sm_hor_loop	# Si $s0 se vuelve cero, entonces habremos llegado al final de la lista 
							# enlazada

	lw $a1, 8($s0)					# Accedemos a la hora del nodo que revisamos y calculamos. Vamos a llamarlo
	jal calcular_bloque				# W-Z
							
							# Revisamos que X > W ^ Y > Z ^ X > Z
	sgt $t0, $s1, $v0				# X > W
	sgt $t1, $s2, $v1				# Y > Z
	sgt $t2, $s1, $v1				# X > Z
	
	and $t0, $t0, $t1    				# X > W ^ Y 
	and $t0, $t0, $t2				# X > W ^ Y > Z ^ X > Z
	
	bnez $t0, continue				# Si $t0 no es cero, significa que este nodo no nos interesa
	
							# Revisamos que W <= X ^ Y <= Z (La clase esta contenida en la encontrada)
	sge $t0, $s1, $v0				# W <= X
	sle $t1, $s2, $v1				# Y <= Z
	
	and $t0, $t0, $t1				# W <= X ^ Y <= Z
		
							# Revisamos que X > W ^ Y > Z ^ X <= Z 
	sgt $t1, $s1, $v0				#  X > W 
	sgt $t2, $s2, $v1				#  Y > Z
	sle $t3, $s1, $v1				#  X <= Z
	
	and $t1, $t1, $t2				# X > W ^ Y > Z
	and $t1, $t1, $t3				# X > W ^ Y > Z ^ X <= Z 
	
	or $t0, $t0, $t1				# (X > W ^ Y > Z ^ X > Z) V (X > W ^ Y > Z ^ X <= Z )
	
	beqz $t0, p_tl					# Si la expresion nos dio 0, significa que no entra en nuestros casos, no imprimimos nada
	bnez $t0, p_class				# Si dio 1, entonces si entra en algun caso y por tanto imprimimos la clase
	
	p_class:
	move $s7, $s0					# Pasamos la dir del nodo que estabamos revisando
	li   $s4, 0					# Decimos que no vamos a imprimir un cuadro de tiempo libre
	b print__
	
	p_tl:
	move $s7, $s0					# Nuestro nuevo nodo actual sera el que estabamos revisando
	move   $a1, $s6					# Especificamos el dia en que estamos
	move $a2, $s3					# Le pasamos a $a1 el horario que estabamos buscando
	li   $s4, 1					# Notificamos que vamos a imprimir una caja de tiempo libre					 
	b print__
	
	continue:
	move $t7, $s0
	lw   $s0, 28($s0)
	b src_sm_hor_loop

 end_src_sm_hor_loop:
 
 	pop ($s3)
	pop ($s2)
	pop ($s1)
	pop ($s0)
	
	move $s7, $t7					# Nuestro nuevo nodo actual sera el ultimo de la lista
	move   $a1, $s6					# Especificamos el dia en que estamos
	move $a2, $s3					# Le pasamos a $a1 el horario que estabamos buscando
	li   $s4, 1					# Notificamos que vamos a imprimir una caja de tiempo libre					 
	b print__

calcular_bloque:
	# Recibe:
	# 	a1: la direccion del horario tal que XXYY: XX es la primera hora, YY la segunda
	# devuelve: 
	#	$v0: el calculo de la primera hora, $v1 el calculo de la segunda hora
	
	primera_hora:
	# Cargamos los dos caracteres de la primera hora
	lb $t0,  ($a1)
	lb $v0, 1($a1)
	
	# Si el primer caracater es "0" no nos interesa
	beq $t0, 48, segundaHora
	# Si no es "0" sumamos ambos 
	add $v0, $v0, $t0
	
	segundaHora:
	# Cargamos los dos caracteres de la segunda hora
	lb $t0,  2($a1)
	lb $v1,  3($a1)
	
	beq $t0, 48, fin_calc_bloque
	add $v1, $v1, $t0
	
fin_calc_bloque: 
	jr $ra

choose_head:
	# Recibe:
	#	a1: un numero en el rango [0, 5]
	# Devuelve:
	#	v1: la dirreccion en memoria de la cabeza asociada
	
	h0: bnez $a1, h1
	la $v1, head0
	jr $ra
	
	h1: bne $a1, 1, h2
	la $v1, head1
	jr $ra
	
	h2: bne $a1, 2, h3
	la $v1, head2
	jr $ra
	
	h3: bne $a1, 3, h4
	la $v1, head3
	jr $ra
	
	h4: bne $a1, 4, h5
	la $v1, head4
	jr $ra
	
	h5: 
	la $v1, head5
	jr $ra

end:
	done
