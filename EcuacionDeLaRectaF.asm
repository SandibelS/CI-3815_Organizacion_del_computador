##########
#Ecucion de la recta usando operaciones de punto
########

.data 

X1: .float 1
Y1: .float 1

X2: .float 3
Y2: .float 3

.text

 main:	lwc1    $f0 X1 	
 	l.s   $f1 Y1 	
 	l.s   $f2 X2 	
 	l.s   $f3 Y2 	
 	
 	sub.s  $f5 $f2 $f0
 	sub.s  $f6 $f3 $f1
 	
 	div.s  $f7 $f6 $f5 #Pendiente de la recta
 	
 	mul.s $f8 $f7 $f0 	#m*x1
 	sub.s  $f9 $f1 $f8 # y1 - m*x1
 	
end:
         li $v0 10
         syscall