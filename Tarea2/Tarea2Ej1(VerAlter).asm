# Tarea 2. Ejercicio 1 (Version Alternativa. Sin la cantidad de numeros enteros a sumar)
#
# Dada una lista de números enteros almacenados de forma 
# consecutiva en memoria, calcular la suma de los
# elementos de la lista 
#
# Nota: Esta es solo una forma alternativa de hacer el
#	ejercicio 1.
#
# Sandibel Soares
# 1710614

.data 
	L: .word 1, 2, 3, 4, 5, 6, 7, 8, 9	# La lista de números enteros a sumar
	F: .word 0				# Un address que indica cuando ya se ha acabado la lista
						# de numeros consecutivos en memoria

.text

main:
	la $t0, L
	la $t1, F
	li $t2, 0		# Donde llevaremos la suma

loop: beq $t0, $t1, print	# Cuando llegemos al address de F significa que ya acabamos con los numeros

lw $s0, ($t0)			# Cargamos el numero a sumar
add $t2, $t2, $s0
add $t0, $t0, 4			# Nos movemos a la siguiente dirección 

bp: b loop

print: 
	move $a0, $t2
	li $v0, 1
	syscall

end:
	li $v0, 10
	syscall
