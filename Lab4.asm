.data
	_exp: .space 1
	var: .float 1024
.text

main: 

lwc1 $f0, var

mfc1 $t0, $f0

#Extraer expo

sll $t0, $t0, 1
srl $t1, $t1, 24 #idk=k
subi $t1, $t1, 127
sb $t1, exp
li $t4, 23
sub $t1, $t4, $t1	

#Extraer mantis

bgez $t0, pos

neg:


j endCases

pos: 
	# Hay que recordar el uno implicito!
	andi $t2, $t0, 0x007FFFFF
	ori $t2, $t2, 0x00800000
	# Al parecer deberia ir a la der no izq
	sllv $t3, $t2, $t1
	
	 
endCases: 