.data 
	salto:   .asciiz "\n"  #10 es ascii
	matriz:  .byte 0:250
	.word 12

.include "utils.asm"

.text 

	la  $t0, matriz
	li  $t1, 25
	li  $t2, 9
	mul $t1, $t1, $t2
	
	add $t2, $t2, 45
	sb $t2, matriz($t1)
	
	li $t2, 45
	
	sb $t2, matriz + 3
	
	sb $t2, matriz + 6
	
	# Esto no se puede hacer, debes averiguar como pasar al modo kernel
	#jal print_console
	
	li $t1, 0
	teqi $t1, 0
	
	


#### Finalizacion del programa  ####
li $v0, 10
syscall


### Imprimir en la consola ###
#print_console

.ktext 0x80000180
# Recuerda guardar lo que necesites en la stack
#push ($ra)

li $s0, 10
la $s1, matriz
li $s5, 46 #46 es un punto para ver que esta trabajando bien, deberia ser 32 que es un espacio

loop_print: beqz $s0, end_print

lb $s6, ($s1)

if: bnez $s6, else
sw  $s5,  0xffff000c  
jal waitPrint
b endif

else: bne $s6, 45, endif
sw  $s6,  0xffff000c
jal waitPrint

endif:
add $s1, $s1, 1
sub $s0, $s0, 1


b loop_print

waitPrint: 
			
		lw   $k1 0xffff0008	#Saber si podemos seguir escribiendo
		andi $k1, 0x00000001
		beqz $k1, waitPrint
		jr $ra
		
	

end_print:
#pop ($ra)
#jr $ra

mfc0 $k0, $14
addi $k0, $k0, 4
mtc0 $k0, $14

eret
