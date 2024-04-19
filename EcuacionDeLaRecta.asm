##########
#Ecucion de la recta
#Sandibel Soares
########

.data 

X1: .word 1
Y1: .word 1

X2: .word 3
Y2: .word 3

.text

 main:	lw   $t0 X1 	#0x00000001
 	lw   $t1 Y1 	#0x00000001
 	lw   $t2 X2 	#0x00000003
 	lw   $t3 Y2 	#0x00000003
 	
 	sub  $t5 $t2 $t0
 	sub  $t6 $t3 $t1
 	
 	div  $t6 $t5
 	mflo $t7   	#Pendiente de la recta
 	
 	mult $t7 $0 	#m*x1
 	mflo $t8 
 	sub  $9 $t0 $t8 # y1 - m*x1
 	
 	


end:
         li $v0 10
         syscall
 	
 	