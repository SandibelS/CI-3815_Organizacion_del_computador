
.text
	li $t0, 9
loop: beqz $t0, end

bne $v0, 115, continue

move $a0, $t0
li $v0, 1
syscall

sub $t0, $t0, 1
continue:

li $v0, 12
syscall

b loop

end:
