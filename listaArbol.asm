.data
	array: .space 20

.text

li $t0, 5

loop:	
	li $v0, 9
	li $a0, 20
	syscall
	
	# Dir 1er hijo
	addi $t1, $t1, 1
	mul $t3, $t1, 4
	sw $v0, array($t3) 
	
	
	li $v0, 8
	lw $a0, array($t3)
	li $a1, 20
	syscall 
	
	# Dir 2do hijo
	addi $t3, $t1, 1
	mul $t3, $t3, 4
	syscall
	mul $t3, $t1, 4
	sw $v0, array($t3) 
	
	
	li $v0, 8
	lw $a0, array($t3)
	li $a1, 20
	syscall
	
	addi $t1, $t1, 1

blt $t1, $t0, loop
