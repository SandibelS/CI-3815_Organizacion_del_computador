# Tarea 2. Ejercicio 1 (Version 1. Dada la cantidad de números )
#
# Dada una lista de números enteros almacenados de forma 
# consecutiva en memoria, calcular la suma de los
# elementos de la lista
#
# Nota: Hay una version alternativa a esta solución que no necesita
#	la cantidad de números en la lista y se encuentra en el 
#	en el archivo Tarea2Ej1(VerAlter).asm
#
# Sandibel Soares
# 1710614


.data 
	L: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10	# La lista de números enteros a sumar.
	n: .word 10				# La cantidad de números que tenemos.

.text

main:
	la $t0 L 
	lw $t1 n
	li $t2 0			# Donde guardaremos la suma.

loop: beqz $t1, print			# Cuando $t1 sea igual a cero, habremos sumado todos los numeros y toca imprimir el
					# resultado.
lw $s0, ($t0)				# Accedemos al número que toca sumar.
add $t2, $t2, $s0 			# sumamos el número de la posicion en donde estamos.

add $t0, $t0, 4				# Nos movemos a la siguiente palabra.
sub $t1, $t1, 1				# Restamos en uno a n.

bp: b loop

print: 
	move $a0, $t2
	li $v0 1
	syscall
	
end: 
	li $v0 10
	syscall


