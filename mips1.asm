.data
#S:.word 11
A:.asciiz "Hola Mundo" 

.text
#LI $t0 2 

#Comentario
#Syscall: PRINT_INT
#LI $v0 1
#LW $a0 S
#SYSCALL

#Syscall: PRINT_STRING
LI $v0 4
LA $a0 A
SYSCALL

