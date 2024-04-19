.data 
	C1N: .asciiz "CI-2613 MEM-008 Algoritmos III"
	C1H: .ascii "-0000T0304-0000T0304-0000-0000"
	
	codigo: .word 0 # En teoria deberia ser .space porque es un espacio que mas tarde usaremos
			# pero cuando usaba esa directiva el codigo comenzaba en la misma palabra que 
			# donde termianaba el string anterior, no se si eso este bien 
	salon: .space 7

.text
	# No necesitamos crear una cabeza en el heap, s0 sera nuestra cabeza
	
	# Pedimos el espacio para un nodo
	li $v0, 9
	li $a0, 28 # 28 bytes = 4 bytes x 7, un byte por campo la direccion quedara guardada en $v0
	syscall
	
	la $s0, ($v0)  #Guardamos en el "head" la direccion del primer nodo

	
	# s0 en vez de v0?
	
	# 1er direccion
	li $t0, 0
	sw $t0, ($v0) # Guardamos en la primera palabra un cero que indica que el antecedente es el head
	add $v0, $v0, 4 # nos movemos a la siguiente palabra para guardar el sig apuntador
	
	# Ahora procedemos a llenar el nodo con lo que necesitamos
	
	#2da direccion
	la $t0, C1N
	#lb $t1, 0($t0) #Esta linea es para comprobar que estamos en la parte correcta del string  
	sw $t0, ($v0)  #guardamos el apuntador del codigo
	
	# 3ra direccion
	add $t0, $t0, 8 # nos movemos 8 caracteres
	add $v0, $v0, 4 # nos movemos a la siguiente palabra para guardar el sig apuntador
	
	#lb $t2, 0($t0)  #Esta linea es para comprobar que estamos en la parte correcta del string  
	sw $t0, ($v0) #Guardamos el apuntador al Salon
	
	#4t direccion
	add $t0, $t0, 8 # nos movemos 8 caracteres otra vez, ahora estamos en donde comienza el nombre de la materia
	add $v0, $v0, 4 # nos movemos a la siguiente palabra para guardar el sig apuntador
	
	#lb $t3, 0($t0)  #Esta linea es para comprobar que estamos en la parte correcta del string  
	sw $t0, ($v0) #Guardamos el apuntador al nombre de la materia
	
	# falta la direccion a: Teorio o Lab, y la del horario
	
	#Ultima direccion, la del nodo siguiente
	add $v0, $v0, 4
	li $t0, -1
	sw $t0, ($v0)
	# Se termino de rellenar el nodo
	
	# Intentemos imprimir lo que hay en el primer nodo
	
	la $t0, codigo #la direccion donde guardaremos el codigo
	
	move $t3, $s0 #movemos lo que hay en la cabeza a t3, deberia ser otro registro, en orden
	add $t3, $t3, 4 # nos movemos a la parte del nodo que donde se guarda la direccion del codigo
	
	lw $t1, ($t3) #cargamos la direccion del codigo
	
	lb $t2, 0($t1) #en t2 guardamos el primer byte de la direccion guardada en t1
	sb $t2, ($t0) 
	
	lb $t2, 1($t1)
	sb $t2, 1($t0)
	
	move $a0, $t0
	li $v0, 4
	syscall
	
	
	
	
	  