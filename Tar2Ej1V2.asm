# Tarea 2. Ejercicio 1
#
# Dada una lista de números enteros almacenados de forma 
# consecutiva en memoria, calcular la suma de los
# elementos de la lista V2
#
# Sandibel Soares
# 1710614

.data 
	L: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
	F: .word 0

.text

main:
	la $t0, L
	la $t1, F
	li $t2, 0

loop: beq $t0, $t1, print

lw $s0, ($t0)
add $t2, $t2, $s0
add $t0, $t0, 4

bp: b loop

print: 
	move $a0, $t2
	li $v0, 1
	syscall

end:
	li $v0, 10
	syscall
