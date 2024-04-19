# Tarea 2, Ejercicio 3
#
# Realice un programa en el cual el usuario introduzca los elementos de un vector de enteros, con un tamaño
# total de 15 elementos. Posteriormente el programa a pedirá un numero a buscar en el vector. Finalmente,
# devolverá si ha encontrado o no el elemento buscado y el número de iteraciones que se han realizado, para
# de esta forma evaluar su eficiencia. En caso de que el elemento este duplicado, se indicara la posición del
# último
#
# Sandibel Soares
# 1710614

.data 

	# Reservamos el espacio en donde guardaremos los numeros que introduzsca el usuario
	N: .space 60 		
	
	# Guardamos los mensajes en donde indicaremos las instrucciones, preguntas y resultados al usuario.
	Indicaciones: .asciiz "Introduzca de uno en uno los enteros para el vector de tamaño 15 \n"
	Pregunta: .asciiz "¿Qué número desea buscar en el vector?\n"
	Encontrado: .asciiz "Se ha encontrado el número. Se ha tomado la siguiente cantidad de iteraciones: "
	noEncontrado: .asciiz "No se ha encontrado el número. Se ha tomado la siguiente cantidad de iteraciones: "

.text

main:
	la $t0, N 
	li $t1, 0 		# Aqui guardaremos el indice del numero en que vamos
	
	la   $t2, Indicaciones	# Se imprimen las indicaciones para la introducción de los numeros
	move $a0, $t2
	li   $v0, 4
	syscall

inputLoop: bge $t1, 15, search  # Cuando ya tengamos los 15 numeros, saltamos a la parte de busqueda.

li $v0, 5			# Pedimos el entero
syscall
sw $v0, ($t0)			# Lo guardamos en la dirreción actual

add $t0, $t0, 4			# Nos movemos a la siguiente palabra
add $t1, $t1, 1			# Sumamos en uno la cantidad de numeros que llevamos

bp: b inputLoop

search:

	la   $t2, Pregunta	# Le preguntamos al usuario que entero quiere buscar en el vector
	move $a0, $t2
	li   $v0, 4
	syscall
	
	li   $v0, 5		# Le pedimos el entero
	syscall
	move $t2, $v0		# Movemos el entero a buscar a un registro temporal 
	
	sub  $t0, $t0, 4	# Como $t0 quedo en una direccion por encima de donde guardamos el ultimo numero
				# Nos movemos a la direccion anterior


searchLoop: beqz $t1, notFound	# Si $t1 llega a cero es porque no conseguimos el numero a buscar 

lw  $s0, ($t0)			# Cargamos el entero por revisar
beq $t2, $s0, found		# Si resulta ser el numero a buscar saltamos en donde imprimimos que lo encontramos

sub $t1, $t1, 1			# Si estamos en esta linea es porque no era igual y seguimos recorriendo el vector 
sub $t0, $t0, 4				

sl: b searchLoop
	
found:
	la $a0, Encontrado	# Indicamos que encontramos el numero
	li $v0, 4
	syscall
	
	li $a0, 15
	sub $a0, $a0, $t1	# Se imprime la cantidad de iteraciones
	li $v0, 1
	syscall
	
	b end

notFound:
	la $a0, noEncontrado	# Indicamos que no encontramos el numero
	li $v0, 4
	syscall
	
	li $a0, 15		# Se imprime la cantidad de iteraciones realizadas
	li $v0, 1
	syscall

end: 
	li $v0, 10
	syscall
