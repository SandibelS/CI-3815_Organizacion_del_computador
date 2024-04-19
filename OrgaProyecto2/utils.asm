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

.macro encender_inters_tcl
	lw  $s0, 0xffff0000
	ori $s0, $s0, 2
	sw  $s0, 0xffff0000
.end_macro

.macro apagar_inters_tcl
	lw   $t0, 0xffff0000
	andi $t0, $t0, 1
	sw   $t0, 0xffff0000
.end_macro