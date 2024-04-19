.macro done
	li $v0 10
	syscall
.end_macro

.macro push ( %r )
	sw   %r ($sp)
	addi $sp $sp 4
.end_macro

.macro pop ( %r )
	subi $sp $sp 4
	lw   %r ($sp)
.end_macro