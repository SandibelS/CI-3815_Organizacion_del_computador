.data 
sp: .asciiz "FeeeToooMooo"

.text
	j main
# Determina si un string esta en mayuscula
# En dado que sea el caso, se fija a $a0 en 1
# se fija en 0 de no ser el caso
fmayusculas:
	li $a0, 0
	_fmloop:
		lbu  $a2, ($a1)
		slti $a3, $a2, 0x61
		sll  $a3, $a3, 1
		or   $a0, $a3, $a0
		and  $a0, $a0, $a3
		
		addi $a1, $a1, 1
	bnez $a2, _fmloop
	jr $ra

main:
	la $a1, sp
	jal fmayusculas