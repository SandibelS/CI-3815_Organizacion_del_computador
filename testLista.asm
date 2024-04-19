.data
	head: .space 20

.text

	li $v0, 9
	li $a0, 32 # 20 bytes, la direccion quedara guardada en $v0
	syscall 
	
	#guardamos en el head el nodo. 
	sw $v0, head
	move $s0, $v0 # Lo guardamos tambien en el registro s0 para tenerlo a mano
	
	# Hagamos otro nodo
	li $v0, 9
	li $a0, 32 
	syscall 
	 
	la $s0, ($v0) # Guardamos la direccion del nuevo nodo en 
	li $t1, 0
	sh $t1, ($s0) #le decimos al pre nodo del primer nodo que su antecedente es el head

	# Hagamos un segundo nodo
	li $v0, 9
	li $a0, 32 
	syscall 
	
	#lw $t1, ($s0) # Recuperamos la direccion del nodo que viene despues del head 
	#en s0 esta la direccion , no tengo que cargar nada
	sw $v0, ($s0) # Guardamos la direccion del nuevo nodo en t1
	
	
	
	
