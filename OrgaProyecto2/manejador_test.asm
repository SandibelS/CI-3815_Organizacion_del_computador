.kdata
	__msg: .asciiz "Yeii \n"

.data 
	msg_termi: .asciiz "Se ha terminado el programa"

.text

#teqi $t1, 0

infinito: nop
b infinito

la   $a0, msg_termi
li   $v0 4
syscall

li $v0, 10
syscall

.ktext 0x80000180 #donde comienza el manejador de interrupciones

mfc0  $k1, $13
andi  $k1,  0x0000100 #mask
beqz   $k1,  nipt
# la interrupcion fue por teclado 
lw    $k1,  0xffff0004
sw    $k1,  0xffff000c  


waitPrint: 	lw   $k1 0xffff0008	#Saber si podemos seguir escribiendo
		andi $k1, 0x00000001
		beqz $k1, waitPrint


# la interrupcion NO fue por teclado 
nipt:
la $a0, __msg
li $v0, 4
syscall

mfc0 $k0, $14
addi $k0, $k0, 4
mtc0 $k0, $14

eret

# Las interrupciones de teclado estan activas 
.data 0xffff0000
	.word 2



