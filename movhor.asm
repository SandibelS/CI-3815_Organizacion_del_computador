st_previous_day:

	b print__
	
st_next_day:
	
	add  $s6, $s6, 1		# Avanzamos al siguiente dia 
	li   $t0, 6		
	div  $s6, $t0
	mfhi $s6
	
	lw   $a1, 8($s7)		# Cargamos el horario del nodo en el que estabamos posicionados
	j  src_sm_hor
	
	empty_list_case_stnd:		# Si llegamos aca es porque la lista siguiente esta vacia y pondremos como
					# nodo actual al ultimo de nuestra lista
	
	sub  $s6, $s6, 1		# Revertimos el avance en el dia 
	li   $t0, 6
	add  $s6, $s6, 6		
	div  $s6, $t0
	mfhi $s6
	
	lw   $t0, ($s7)
	lw   $t1, 28($t0)
	
	loop_elc: beqz $t1, pos_ln
		lw   $t0, ($t1)
		lw   $t1, 28($t0)
	b loop_elc

	pos_ln:
		lw   $a1, 8($s7)
		li   $a2, 1
		li   $s4, 1
		move $s7, $t0
		b print__

src_sm_hor:
	# Recibe:
	#	$a1 el horario del nodo en que se estaba posicionado y que se busca en el siguiente dia
	
	push ($s0)		
	push ($s1)
	push ($s2)
	push ($s3)
	
	lw   $s0, 28($s6)				# Cargamos la direccion que contenga la cabeza del dia nuevo
	
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
	bnez $t0, p_class				# SI dio 1, entonces si entra en algun caso y por tanto imprimimos la clase
	
	p_class:
	move $a1, $s0					# Pasamos la dir del nodo que estabamos revisando
	li   $a2, 0					# Decimos que no vamos a imprimir un cuadro de tiempo libre
	li   $s4, 0
	b end_src_sm_hor
	
	p_tl:
	move $s7, $s0					# Nuestro nuevo nodo actual sera el que estabamos revisando
	move $a1, $s3					# Le pasamos a $a1 el horario que estabamos buscando
	li   $a2, 1					# Notificamos que vamos a imprimir una caja de tiempo libre
	li   $s4, 1					 
	b  end_src_sm_hor					# Si no esta vacia, buscaremos el ultimo nodo de la

	
	continue:
	lw  $s0, 28($s0)
	b src_sm_hor_loop

 end_src_sm_hor_loop:
 	
 	move $a1, $s6					# Obtenemos la cabeza para saber si la lista estaba vacia
 	jal choose_head
 	
 	lw   $t0, 28($s6) 
 	
 	beqz $t0, 
 						
 end_src_sm_hor:
	pop ($s3)
	pop ($s2)
	pop ($s1)
	pop ($s0)
	b print__	
