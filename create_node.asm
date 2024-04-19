# Este archivo crea un nodo donde los campos de los nodos son apuntadores a donde comienzan
# los siguientes campos: Direccion del nodo anterior (se incializa en 0), Dia de la semana de la clase,
# 			 horario de la clase, codigo, nombre, salon, teoria/lab, direccion del nodo siguiente
#			 (se inicializa en 0)
#
.macro create_node (%dirMat, %dirHorario, %dia)
	# Cometi un error con los registros, asi que me toca guardar lo que hay en dirHorario en $s1 por ahora
	# hay que arreglarlo si hay tiempo
	move $s1, %dirHorario
	
	# Pedimos el espacio para un nodo en el heap
	li $v0, 9
	li $a0, 28 # 32 bytes = 4 bytes x 8, 4 bytes por campo. La direccion quedara guardada en $v0
	syscall
	
	# Campo 1: direccion del nodo anterior (se incializa en 0)
	li $s0, 0
	sw $s0, ($v0) 	# guardamos el apuntador
	add $v0, $v0, 4 # nos movemos a la siguiente palabra para guardar el sig apuntador

	# Campo 2: dia de la semana de la clase (Como es un esntero nos ayuda a saber en que cabeza va)
	# Nota: En este campo estamos desperdiciando espacio (por ser un entero y no una direccion), pero creo que es inevitable
	sw %dia, ($v0) #dia
	add $v0, $v0, 4
	
	# Campo 3: Horario de la clase
	#move $s0, %dirHorario
	add  $s0, $s1, 1 #ignoramos el caracter T/L
	sw   $s0, ($v0) 
	add  $v0, $v0, 4
	
	# Campo 4: codigo
	sw %dirMat, ($v0) # Como el string comienza por el codigo de la materia, guardamos el apuntador 
	add %dirMat, %dirMat, 8 # nos movemos 8 caracteres a la der (La cantidad de caracteres del codigo mas el espacio)
	add $v0, $v0, 4
	
	# Campo 5: salon (Seria mejor que primero guardaramos el campo del nombre, pero es dificil movernos sin el tam del nombre)
	sw %dirMat, ($v0) #Guardamos el apuntador al Salon
	add %dirMat, %dirMat, 8 #nos movemos 8 caracteres a la der (La cantidad de caracteres del salon mas el espacio)
	add $v0, $v0, 4
	
	#Campo 6: nombre
	sw %dirMat, ($v0) #Guardamos el apuntador a donde comienza el nombre de la materia
	add $v0, $v0, 4
	
	#Campo 7: teoria/lab
	sw $s1, ($v0)
	add $v0, $v0, 4
	
	#Campo 8: direccion del nodo siguiente (se incializa en 0)
	li $s0, 0
	sw $s0, ($v0) 	# guardamos el apuntador
	
.end_macro
