# En este archivo se encuentra el codigo que se encarga de procesar los datos y generar los nodos respectivos

# Esta seccion de datos es para probar, no deberia ir aca, creo
#.data
#	.include "d.asm"
	
#	# Necesitamos espacio para los nodos que seran las cabezas de nuestro dias
#	head0: .word  0, 0, 0, 0, 0, 0, 0, 0			# Lunes
#	head1: .word  0, 0, 0, 0, 0, 0, 0, 0			# Martes
#	head2: .word  0, 0, 0, 0, 0, 0, 0, 0			# Miercoles
#	head3: .word  0, 0, 0, 0, 0, 0, 0, 0			# Jueves
#	head4: .word  0, 0, 0, 0, 0, 0, 0, 0			# Viernes
#	head5: .word  0, 0, 0, 0, 0, 0, 0, 0			# Sabado

#.macro done
#	li $v0 10
#	syscall
#.end_macro

#.macro push ( %r )
#	sw   %r ($sp)
#	addi $sp $sp 4
#.end_macro
#
#.macro pop ( %r )
#	subi $sp $sp 4
#	lw   %r ($sp)
#.end_macro

#.text
.macro process_data

# Si esto se convierte en una funcion, hay que poner lo de guardar $ra en el stack
	
process_data:
	# No se recibe nada 
	# No se devuelve nada
	
	la $a1, C1N
	la $a2, C1H
	jal generate_nodes
	
	la $a1, C2N
	la $a2, C2H
	jal  generate_nodes
	
	la $a1, C3N
	la $a2, C3H
	jal generate_nodes
	
	la $a1, C4N
	la $a2, C4H
	jal generate_nodes
	
	la $a1, C5N
	la $a2, C5H
	jal generate_nodes
	
	la $a1, C6N
	la $a2, C6H
	jal generate_nodes
	
	b end_process_data

generate_nodes:
	# recibe:
	#	a1: la direccion de la cadena de caracteres en memoria que especifica codigo, salon y nombre de materia (si hay materia)
	#	a2: la direccion de la cadena de caracteres en memoria que especifica en que dias hay clases y su horario 
	# no devuelve nada
	
	
	move $s1, $a1				# guardamos a CiN en s1
	move $s2, $a2				# guardamos a CiH en s2
	
	push ($ra)
	jal is_there_class			# Revisamos si hay una clase en la dirreccion pasada
	pop ($ra)
	
	bnez $v1, gn		 		# Si $v1 es diferente a 0, entonces creamos los nodos correspondientes
	jr $ra					# De lo contrario, no hay nada que hacer y nos devolvemos
	
gn:	li $s3, 6 				# Vamos a generar un maximo de 6 nodos por materia

	push ($ra)				# Esta funcion incluye llamadas a otras funciones, por lo que apilamos a $ra para no perderla

generate_nodes_loop: beqz $s3, end_generate_nodes
	
	move $a1, $s2	# donde buscaremos la prox clase
	move $a2, $s3	# los dias que llevamos revisados
	jal search_L_or_T
	move $s2, $v1		# La direccion de la clase encontrada (si es que se encontro)
	add  $s2, $s2, 5	# Le sumamos 5, porque vamos a comenzar a buscar la siguiente clase en el dia deespues
	move $s3, $v0		# Actualizamos la cantidad de dias revisados
	beqz $v0, end_generate_nodes		#  si v0 es cero ya revisamos todos los dias 
	
	move $a1, $s1				# dir de CiN
	sub $a2, $s2, 5				# direccion del horario de la clase
	li   $a3, 5
	sub  $a3, $a3 $v0			# dia = 5 - dias_por_revisar  (0: Lunes, 1: Martes, ...)
	jal create_node
	
	move $t0, $v1 #guardamos aqui temporalmente la direccion del nodo
	
	move $a1, $v1
	jal choose_day	# escogemos la cabeza en donde ira el nodo
	
	move $a1, $v1   # pasamos la direccion de la cabeza encontrada
	move $a2, $t0	# recuperamos la direccion del nodo creado
	jal add_node	
		
b generate_nodes_loop

end_generate_nodes:
	pop ($ra)				# Al terminar la funcion, desempilamos la direccion a la que hay que volver
	jr  $ra
	
is_there_class:
	# recibe:
	#	a1: la direccion de la cadena de caracteres en memoria que especifica codigo, salon y nombre de materia (si hay materia)
	# devuelve:
	#	$v1: 1 si hay materia, 0 de lo contrario
	
	lb  $a1, ($a1)				# Cargamos el primer byte de la cadenba
	sne $v1, $a1, 45			# $v1 sera 1 si el primer caracter es diferente a "-", 0 de lo contrario
	jr $ra 
	
search_L_or_T:
	# Recibe: 
	#	  $a1: Direccion en donde se comienza a a buscar el caracter L o T
	#	  $a2: La cantidad de dias que podemos revisar, debe ser mayor que 0
	# Devuelve:
	# 	  $v0: La cantidad de dias que faltaron por revisa, si es cero es que ya se revisaron todos los dias y no se encontro otra clase
	#	  $v1: La direccion donde se encontro el caracter buscado (Si es que se consiguio)

	search_L_or_T_loop: ble $a2, 0, end_search_L_or_T
	
	lb  $t0, ($a1)			# Cargamos el primer byte del dia para ver que caracter representa
	sub $a2, $a2, 1			# Revisamos un dia
	bne $t0, 45, end_search_L_or_T	# Si conseguimos un caracter diferente a "-" tenemos nuestro L o T
	add $a1, $a1, 5			# En cambio, si conseguimos un "-" saltamos 5 posiciones adelante
	
	b search_L_or_T_loop
	
end_search_L_or_T:

	move $v0, $a2
	move $v1, $a1
	
	jr $ra

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
	sw   $t1, ($t0) 			# Guardamos la direccion del horario en el tercer campo
	add  $t0, $t0, 4 
	
	# Campo 4: codigo
	sw  $a1, ($t0) 				# Como el ascii comienza por el codigo de la materia, guardamos el apuntador 
	add $a1, $a1, 8 			# Nos movemos 8 caracteres a la der (La cantidad de caracteres del codigo mas el espacio)
	add $t0, $t0, 4
	
	# Campo 5: salon 
	sw  $a1, ($t0)				# Guardamos el apuntador al Salon en el quinto campo
	add $a1, $a1, 8 			# Nos movemos 8 caracteres a la der (La cantidad de caracteres del salon mas el espacio)
	add $t0, $t0, 4
	
	#Campo 6: nombre
	sw $a1, ($t0) 				#Guardamos el apuntador a donde comienza el nombre de la materia
	add $t0, $t0, 4
	
	#Campo 7: teoria/lab
	sw  $a2, ($t0)
	add $t0, $t0, 4
	
	#Campo 8: direccion del nodo siguiente (se incializa en 0)
	li $t1, 0
	sw $t1, ($t0) 	
	
	jr $ra

add_node: 
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
	sw  $t0, ($a1)			# Guardamos en ese campo la direccion del nodo en t0
	
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
	

choose_day:
	# Recibe 
	#	$a1: la direccion de un nodo 
	# Devuelve:
	#	$v1: la direccion de la cabeza en memoria que corresponda con el dia de la clase
	
	add $a1, $a1, 4
	lw  $a1, ($a1)
	
	h_lunes: bne $a1, 0, h_martes
		la $v1, head0
		jr $ra
	
	h_martes: bne $a1, 1, h_miercoles
		la $v1, head1
		jr $ra
	
	h_miercoles: bne $a1, 2, h_jueves
		la $v1, head2
		jr $ra
	
	h_jueves: bne $a1, 3, h_viernes
		la $v1, head3
		jr $ra
	
	h_viernes: bne $a1, 4, h_sabado
		la $v1, head4
		jr $ra
	
	h_sabado: bne $a1, 5, error_chs_day
		la $v1, head5
		jr $ra
	
	error_chs_day:
		li $v1, -1
		jr $ra
	
end_process_data:

.end_macro