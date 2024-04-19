# Dada la cabeza de una lista enlazada y la direccion de un nodo, se agrega la direccion del nodo
# a la cabeza de la lista enlazada 

# Ojo con este codigo, no se ha probado con todos los casos de choques de materias


# datos solo para probar
.data
	cabeza: .word 0, 0, 0, 0, 0, 0, 0, 0
	
	nodo1: .word 0, 0, 0, 0, 0, 0, 0, 0
	nodo2: .word 0, 0, 0, 0, 0, 0, 0, 0
	nodo3: .word 0, 0, 0, 0, 0, 0, 0, 0
	nodo4: .word 0, 0, 0, 0, 0, 0, 0, 0
	
	hora1: .ascii "0102"
	hora2: .ascii "0102"
	hora3: .ascii "0304"
	hora4: .ascii "0405"
	
.macro push ( %si )
	sw   %si ($sp)
	addi $sp $sp 4
.end_macro

.macro pop( %si )

	subi $sp $sp 4
	lw   %si ($sp)

.end_macro
	
.text

##############################################################

#Ponemos las horas en donde van

la $t0, nodo1
la $t1, hora1
add $t0, $t0, 8
sw $t1, ($t0)

la $t0, nodo2
la $t1, hora2
add $t0, $t0, 8
sw $t1, ($t0)

la $t0, nodo3
la $t1, hora3
add $t0, $t0, 8
sw $t1, ($t0)

la $t0, nodo4
la $t1, hora4
add $t0, $t0, 8
sw $t1, ($t0)
##############################################################

la $a1, cabeza				# Probamos la funcion con nuestros datos
la $a2, nodo1
jal add

la $a1, cabeza				
la $a2, nodo2
jal add

la $a1, cabeza				
la $a2, nodo3
jal add

la $a1, cabeza				
la $a2, nodo4
jal add

li $v0, 10
syscall

add:  ########################### Hay que arreglar la funcion para que modifique bien la cabeza
# recibe: a1 cabeza de la lista
# recibe: a2 direccion del nodo a agregar

# Empila ra 
push ($ra)
	
add  $t0, $a1, 28			# Primero se revisa si la cabeza esta vacia, si lo esta saltamos a agregar el primer elemento
lw   $t0, ($t0) 			# en t0 guardamos el contenido de la cabeza, para saber si esta vacia
beqz $t0, agregar_primer_elemento	# no se si guardar la direccion de la cabeza en algun s 

					# Si no estaba vacia, Obtenemos el horario del nodo y buscamos en la lista donde ponerlo

push ($s0)				# Como vamos a usar los s0, s1, s2, s3 debemos guardar lo que sea que contengan antes 	
push ($s1)				# de usarlos
push ($s2)
push ($s3)

move $s0, $a2				# No podemos perder la direccion de nuestro nodo, lo nececitamos para agregarlo
#move $s2, $t0  			# Se le pasa a s2 la direccion de que hay en la cabeza (que sabemos que no es 0)
move $s2, $a1
add  $s2, $a1, 28
add  $s1, $s0, 8 			# En s1 vamos a guardar la direccion de la hora de nuestro nodo
li   $s3, 0				# s3 nos ayuda a saber si llegamos al final de la lista


add_loop: bnez $s3, agregar_al_final    # Si s3 pasa a ser 1, significa que tenemos que agregar el nodo al final

lw   $s2, ($s2)
add  $s2, $s2, 8 			# Se busca el horario del nodo actual

move $a1, $s1				# a1: hora del nodo1
move $a2, $s2				# a2: hora del nodo2
jal  check_hour_2			# Se revisa si hay que posicionar a nodo1 con respecto a nodo2

pos_1: bne $v1, 1, pos_2
move $a1, $s0
sub  $a2, $s2, 8
b  posicionar_antes

pos_2: bne $v1, 2, siguiente
move $a1, $s0
sub  $a2, $s2, 8
b  posicionar_despues

siguiente:
add $s2, $s2, 20 			# Nos movemos hasta el campo que indica la dir del siguiente nodo (si es que hay)
lw  $t0, ($s2)
seq $s3, $t0, 0				#Si la siguiente direccion es 0, llegamos al final de la lista
#lw  $s2, ($s2)   			# Cargo la nueva direccion en s2

b add_loop

posicionar_antes:
	# recibe a1: la direccion de nodo1
	# recibe a2: la direccion de nodo2
	# se posiciona nodo1 <-> nodo2
	# no devuelve nada. salta a desempilar y luego se termina la funcion
	
	lw  $t0, ($a2)			# Obtengo la direccion del nodo anterior de a2 (que es diferente a 0)
	sw  $t0, ($a1)			# Sera el nuevo nodo anterior de a1
	add $t0, $t0, 28		#me muevo al campo del siguiente nodo de t0
	sw  $a1, ($t0)			# ahora a1 sera el siguiente nodo luego de t0
	
	sw  $a1, ($a2)			# Guardamos la direccion de a1 como nuevo nodo prev de a2
	
	add $a1, $a1, 28		# Avanzamos al campo de sig nodo de a1
	sw  $a2, ($a1)			# Guardamos la direccion de a2 en el campo del sig nodo de a1
	
	b desempilar_s
	
posicionar_despues:
	# recibe a1: la direccion de nodo1
	# recibe a2: la direccion de nodo2
	# se posiciona nodo2 <-> nodo1
	# no devuelve nada. salta a desempilar y luego se termina la funcion
	
	sw  $a2, ($a1)			# El nodo previo del nodo1 sera nodo2
	add $a2, $a2, 28		# avanzamos al campo con ;a siguiente nodo de s2
	
	lw  $t0, ($a2)			# cargamos lo que haya en la direccion
	sw  $a1, ($a2)			# Guardamos a a1 como el siguiente nodo de a2
	
	beqz $t0, desempilar_s		# Si t0 es cero, ya terminamos
	
	sw  $a1, ($t0)			# Si no era cero, guardamos a a1 como nodo anterior de t0
	add $a1, $a1, 28		# avanzamos hasta el campo del siguiente nodo de a1
	sw  $t0, ($s1)			# Guardamos en ese campo la direccion del nodo en t0
	
	b desempilar_s
	

agregar_al_final:
	# se asume que en s0 esta la direccion del nodo a posicionar y en s2 la dir del ultimo nodo de la lista
	#add $s2,  $s2, 28		# se avanza hasta el campo del siguiente nodo de nodo1
	
	sw  $s0, ($s2)			# el siguiente nodo de s2 sera el nodo que buscamos posicionar
	sub $s2, $s2, 28
	sw  $s2, ($s0)
	
	
	#b desempilar_s
	
desempilar_s:
	pop ($s3)
	pop ($s2)
	pop ($s1)
	pop ($s0)
	b end_add

agregar_primer_elemento:
	sw  $a1, ($a2)			# guardamos la direccion de la cabeza en el prev del nodo
	add $a1,  $a1, 28
	sw  $a2, ($a1)			# guardamos la direccion del nodo en la cabeza
	
end_add:
	# Desempila $ra
	subi $sp $sp 4
	lw $ra ($sp)
	
	jr $ra


check_hour_2:
	# a1 la direccion de la hora de un nodo a posicionar
	# a2 la direccion de la hora de otro nodo
	#
	# devuelve v1: 0 si no hay que posicionar el nodo con respecto a a2
	#	       1 si hay que ponerlo antes
	#              2 si hay que ponerlo despues
	
	# manipula a t0, t1, t2, t3, t4, t5, t6
	
	# Empila ra (deberia volverlo macro)
	sw $ra ($sp)
	addi $sp $sp 4
	
	#calcular el bloque para la primera clase
	lw $a1, ($a1)
	jal calcular_bloque
	push ($s0)
	move $s0, $v0
	move $t1, $v1
	
	#calcular el bloque para la segunda clase
	move $a1, $a2
	lw $a1, ($a1)
	jal calcular_bloque
	move $t2, $v0
	move $t3, $v1
	
	move $t0, $s0
	pop ($s0)
	
	# Revisar si x > w ^ y > z
	sgt $t4, $t0, $t2
	sgt $t5, $t1, $t3
	
	and $t4, $t4, $t5
	
	beq $t4, 1, devolver_cero 
	
	# Revisar si x = w ^ y > z v x > w ^ y = z
	
	# x = w ^ y > z
	seq $t4, $t0, $t2
	sgt $t5, $t1, $t3
	and $t4, $t4, $t5
	
	# x > w ^ y = z
	sgt $t5, $t0, $t2
	seq $t6, $t1, $t3
	and $t5, $t5, $t6
	
	or $t4, $t4, $t5
	
	beq $t4, 1, devolver_dos
	
	# Si ninguno de los casos de antes se cumplieron, entonces
	li $v1, 1
	b end_check_hour
	
	
	devolver_cero:
		li $v1, 0
		b end_check_hour
	
	devolver_dos:
		li $v1, 2
		b end_check_hour
	
end_check_hour:
	# Desempila $ra
	subi $sp $sp 4
	lw $ra ($sp)
	
	jr $ra
	
calcular_bloque:
	# a1 la direccion del horario tal que XXYY: XX es la primera hora, YY la segunda
	# devuelve: $v0 el calculo de la primera hora, $v1 el calculo de la segunda hora
	# manipula a: t0
	
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

