
.text
	li $t0, 50
	jal add_s 
	li $v0, 10
	syscall
.include "ejemploGlobl.asm"