	.data
	.half 1
	.byte 0
carnet: .asciiz "1710614"	# Sustituir por el carnet (sin guion) de alguno de los
                         	# integrantes del grupo

    	.word 1, 2
ing:	.word 0, 0

	.text
main:
	li $t0, 4

	la $t1, carnet
	la $t2, ing

loop: beqz $t0, end

lb $s0, 0($t1)
lb $s1  1($t1)

xor $s0, $s0 $s1
xor $s1, $s0 $s1
xor $s0, $s0 $s1

sb $s0, 0($t2)
sb $s1, 1($t2)

add $t0, $t0, -1
add $t1, $t1, 2
add $t2, $t2, 2

bp:	b loop

end:
	li $v0 10
	syscall
