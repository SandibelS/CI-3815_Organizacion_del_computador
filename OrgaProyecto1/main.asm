.data
	.include "d.asm"
	
	# Necesitamos espacio para los nodos que seran las cabezas de nuestro dias
	head0: .word  0, 0, 0, 0, 0, 0, 0, 0			# Lunes
	head1: .word  0, 0, 0, 0, 0, 0, 0, 0			# Martes
	head2: .word  0, 0, 0, 0, 0, 0, 0, 0			# Miercoles
	head3: .word  0, 0, 0, 0, 0, 0, 0, 0			# Jueves
	head4: .word  0, 0, 0, 0, 0, 0, 0, 0			# Viernes
	head5: .word  0, 0, 0, 0, 0, 0, 0, 0			# Sabado

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


.include "process_data.asm"
.include "longest_name.asm"
.include "first_class.asm"

.text

process_data
longest_name
first_class