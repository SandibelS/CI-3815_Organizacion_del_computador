##########
#Suma de 4 números
#Sandibel Soares
########

.data

A: .byte 17
B: .byte 10
C: .byte 61
D: .byte 4


.text

main:   lb $t0 A     # 17 = 16 + 1 (Base 10).  11 = 10 + 1 (Base 16)
		     # 0x00000011
  	lb $t1 B     # 10 (Base 10). a (Base 16)
  		     # 0x0000000a
        lb  $t2 C     # 61 = 16 + 16 + 16 + 13  (Base 10)
        	     # 3d = 10 + 10 + 10 + d (Base 16)
        	     # 0x0000003d
        lb $t3 D     # 4 (Base 10 y Base 16)
        	     # 0x00000004
       
       	# Suma de los 4 numeros, el resultado se guarda en $t4
        add $t4, $t0, $t1
        add $t4, $t4, $t2
        add $t4, $t4, $t3   
       
         # Se imprime la suma
         li $v0 1
         move $a0, $t4
         syscall

end:
         li $v0 10
         syscall