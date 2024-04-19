# Este archivo devuelve la direccion del primer nodo que representa la primera clase
# en la semana.
#
# Recorre las cabezas de las listas enlazadas desde el 0 hasta el 6 (Es decir, desde lunes a viernes)
# Si no se encontro un nodo, se devuelve cero
#
# Este archivo no necesita input (pero necesita saber la dir del lunes)
# modifica los registros $t0, $t1
# devuelve la direccion en $v1

# Estos datos es para poder probar el codigo
#.data
#	head0: .word 0,0,0,0,0,0,0,0
#	head1: .word 0,0,0,0,0,0,0,0
#	head2: .word 0,0,0,0,0,0,0,0
#	head3: .word 0,0,0,0,0,0,0,3
#	head4: .word 0,0,0,0,0,0,0,4
#	head5: .word 0,0,0,0,0,0,0,5

#.text 
.macro first_class

	li  $t0, 6		# Vamos a iterar un maximo de 6 veces
	la  $t1, head0	 	# Cargamos la dir de la cabeza del lunes
	add $t1, $t1, 28	# Nos movemos al campo del siguiente nodo
	li  $v1, 0		# En $v1 guardaremos la direccion del nodo, lo iniciamos en 0
				# para que este sea el valor que se devuelve si resulta que no 
				# encontramos el nodo.	#Creo que no es necesario

srch_fcls_loop: beqz, $t0, class_found	
	
	lw   $v1, ($t1)		# Cargamos En v1 la direccion que este en la cabeza
	bnez $v1, class_found	# Si no esta vacia, entonces encontramos la direccion de nuestra primera clase 
	add  $t1, $t1, 32	# Si esta vacia, pasamos a la siguiente cabeza
	sub  $t0, $t0, 1	# Acualizamos la cantidad de cabezas revisadas

b srch_fcls_loop

class_found:
	move $s7, $v1		# En s7 se guarda la direccion del nodo actual que se manda a imprimir
	#move $a0, $v1
	#li $v0, 1
	#syscall
  
.end_macro