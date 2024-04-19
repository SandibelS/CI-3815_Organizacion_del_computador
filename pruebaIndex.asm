.data
	nodo: .word 0, 1, 2, 3, 4, 5, 6, 7, 8

.text
	la $t0, nodo
	lw $a0, 8($t0)
	li $v0, 1
	syscall