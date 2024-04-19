## Este archivo crea un nodo donde los campos de los nodos son apuntadores a donde comienzan
# los siguientes campos: Direccion del nodo anterior (se incializa en 0), Dia de la semana de la clase,
# 			 horario de la clase, codigo, nombre, salon, teoria/lab, direccion del nodo siguiente
#			 (se inicializa en 0)

.macro create_node_fun 

create_node:
	# Recibe:
	#	a1: direccion de un CiN
	#	a2: direccion del horario de una clase de CiN
	#	a3: dia en la semana de la clase
	#
	# Devuelve:
	#	$v1 la direccion del nuevo nodo creado en el heap
	
	
	li $v0, 9				# Pedimos el espacio para un nodo en el heap
	li $a0, 32			        # 32 bytes = 4 bytes x 8, 4 bytes por campo. La direccion quedara guardada en $v0
	syscall
	
	move $t0, $v0 				# a lo largo del codigo, nos vamos a ir moviendo por la direccion del nodo
	move $v1, $v0				# movemos la direccion en el registro que se da como resultado

	# Campo 1: direccion del nodo anterior (se incializa en 0)
	li  $t1, 0
	sw  $t1, ($t0) 				# Guardamos el apuntador en el primer campo 
	add $t0, $t0, 4 			# Nos movemos a la siguiente palabra (campo) para guardar el sig apuntador
	
	# Campo 2: dia de la semana de la clase (Como es un entero nos ayuda a saber en que cabeza va)
	sw  $a3, ($t0) 				# Guardamos el dia en el segundo campo
	add $t0, $t0, 4
	
	# Campo 3: Horario de la clase
	add  $t1, $a2, 1 			# Ignoramos el caracter T/L
	sw   $s0, ($t0) 			# Guardamos la direccion del horario en el tercer campo
	add  $t0, $t0, 4 
	
	# Campo 4: codigo
	sw  $a1, ($t0) 				# Como el ascii comienza por el codigo de la materia, guardamos el apuntador 
	add $a1, $a1, 8 			# Nos movemos 8 caracteres a la der (La cantidad de caracteres del codigo mas el espacio)
	add $t0, $t0, 4
	
	# Campo 5: salon 
	sw  $a1, ($t0)				# Guardamos el apuntador al Salon en el quinto campo
	add $a1, $a1, 8 			# Nos movemos 8 caracteres a la der (La cantidad de caracteres del salon mas el espacio)
	add $t0, $t0, 4
	
	#Campo 7: teoria/lab
	sw  $a3, ($v0)
	add $t0, $t0, 4
	
	#Campo 8: direccion del nodo siguiente (se incializa en 0)
	li $s1, 0
	sw $t1, ($t0) 	
	
	jr $ra
	
.end_macro