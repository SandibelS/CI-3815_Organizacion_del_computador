.data
	a: .byte 97
	bb: .byte 98
	c: .byte 99
	d: .byte 100
	
	ini_txt: .byte 7

.text
	li $t1, 0
	teqi $t1, 0
	
.ktext 0x80000180

lb  $k1, a
sw  $k1,  0xffff000c  
jal waitPrint

lb  $k1, bb
sw  $k1,  0xffff000c  
jal waitPrint

lb  $k1, c
sw  $k1,  0xffff000c  
jal waitPrint

lb  $k1, ini_txt
sw  $k1,  0xffff000c
li  $k1, 1
li  $k0, 0xffff000c
#sb  $k1, 20($k0)
#sb  $k1, 8($k0)
jal waitPrint

lb  $k1, d
sw  $k1,  0xffff000c  
jal waitPrint

b fin 

waitPrint: 
			
		lw   $k1 0xffff0008	#Saber si podemos seguir escribiendo
		andi $k1, 0x00000001
		beqz $k1, waitPrint
		jr $ra

fin: 
mfc0 $k0, $14
addi $k0, $k0, 4
mtc0 $k0, $14

eret