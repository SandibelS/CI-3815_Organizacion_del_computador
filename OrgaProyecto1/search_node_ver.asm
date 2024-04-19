# Este codigo recorre una lista enlazada circular la cantidad de veces indicada y en el sentido indicado
# "vertical" es solo una forma de diferenciar cuando se buscan clases en el mismo dia y 
# no en diferentes dias


# Estos datos son para probar
.data
	cabeza: .word 0
	.space 28 
	node1: .word 0, 0, 0, 0, 0, 0, 0, 0
	node2: .word 0, 0, 0, 0, 0, 0, 0, 0
	node3: .word 0, 0, 0, 0, 0, 0, 0, 0
	node4: .word 0, 0, 0, 0, 0, 0, 0, 0
	node5: .word 0, 0, 0, 0, 0, 0, 0, 0
	
.text

#Vamos a conectar los nodos

#cabeza <-> node1
la $t0, cabeza
la $t1, node1
sw $t1, ($t0)
sw $t0, ($t1)


# nodo1 <-> nodo2 
la $t0, node1
la $t1, node2
sw $t0, ($t1)

add $t0, $t0, 28
sw $t1, ($t0)

# nodo2 <-> nodo3 
la $t0, node3
sw $t1, ($t0)

add $t1, $t1, 28
sw $t0, ($t1)

# nodo3 <-> nodo4
la $t1, node4
sw $t0, ($t1) 

add $t0, $t0, 28
sw $t1, ($t0)

# nodo4 <-> nodo5 
la $t0, node5
sw $t1, ($t0)

add $t1, $t1, 28
sw $t0, ($t1)

#node5 -> cabeza
la $t1, cabeza

add $t0, $t0, 28
sw $t1, ($t0)
###################

# Codigo #

	# a0: direccion de la cabeza
	# recibe a1: direccion del nodo actual
	# a2: sentido (0 abajo, 1 arriba)
	# a3: cantidad de movimientos
	
	la $a0, cabeza
	la $a1, node3
	li $a2, 0
	
	li $a3, 2
	
			
	beq $a2, 0, bajar
	
subir:	
	lw $t0, ($a1)
	move $t1, $a3
	sub $t1, $t1, 1

	sne $t2, $t0, $a0
	sne $t3, $t1, 0
	and $t2, $t2, $t3
	
	src_nd_vr_loop_sub: beq, $t2, 0,  end_src_nd_vr
	
	lw $t0, ($t0)
	sub $t1, $t1, 1
	
	sne $t2, $t0, $a0
	sne $t3, $t1, 0
	and $t2, $t2, $t3
	
	b src_nd_vr_loop_sub

bajar:  
	move $t0, $a1
	move $t1, $a3
	add $t0, $t0, 28
	lw $t0, ($t0)
	sub $t1, $t1, 1
	
	sne $t2, $t0, $a0
	sne $t3, $t1, 0
	and $t2, $t2, $t3
	
	src_nd_vr_loop_baj: beq, $t2, 0,  end_loop_baj
	
	add $t0, $t0, 28
	lw $t0, ($t0)
	sub $t1, $t1, 1
	
	sne $t2, $t0, $a0
	sne $t3, $t1, 0
	and $t2, $t2, $t3
	
	b src_nd_vr_loop_baj
	
	end_loop_baj:
	#sub $t0, $t0, 28
	b end_src_nd_vr
	
	end_src_nd_vr:
	move $v0, $t0
	move $v1, $t1 
	

	
	# Para probar
	move $a0, $v0
	li $v0, 1
	syscall
