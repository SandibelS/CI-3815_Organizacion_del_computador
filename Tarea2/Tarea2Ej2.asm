# Tarea 2. Ejercicio 2
#
# Dada una lista de números positivos y negativos, calcular 
# cuantos números positivos y cuantos números negativos 
# hay en la lista
#
# Sandibel Soares
# 1710614

.data 
	# Mensajes que usaremos al momento de dar la solución.
	pos: .asciiz "La cantidad de numeros positivos es: "
	neg: .asciiz "\nLa cantidad de numeros negativos es: "
	
	# Se asume que los enteros estan guardados de forma consecutiva.
	N: .word 1, -2, 3, -4, 5, -6, 7, -8, 9, -10
	# n será la cantidad de numeros a revisar.	
	n: 10 
.text 

main: 
	la $t0, N
	lw $t1, n
	li $t2, 0		# Donde vamos a guardar la cantidad de numeros positivos. Como cada numero 
				# entero solo puede ser postivo o negativo, solo contamos 
		    		# los positivos y luego calculamos los negativos.		

loop: beqz $t1, print		# Cuando se termine de revisar los numeros, imprimimos el resultado

lw  $s0, ($t0)			# Cargamos el numero a revisar

blt $s0, $zero, continue 	# Si el numero es negativo, avanzamos sin hacer nada
add $t3, $t3, 1	 		# Si es positivo, sumamos en uno nuestro contador

continue: sub $t1, $t1, 1	
	  add $t0, $t0, 4	# Pasamos a la siguiente palabra en la memoria

bp: b loop 

print:
	# Las siguientes lineas se encargan de:
	#	Imprimir el mensaje guardado en pos
	#	Imprimir el resultado de los numeros positivos
	#	Imprimir el mensaje guardado en neg
	#	Iimprimir el resultado de numeros negativos
	
	la   $a0, pos		
	li   $v0, 4
	syscall
	
	move $a0, $t3 
	li   $v0, 1
	syscall
	
	la   $a0, neg
	li   $v0, 4
	syscall

	sub  $a0, $t2, $t3
	li   $v0, 1
	syscall

end:
	li $v0, 10
	syscall
