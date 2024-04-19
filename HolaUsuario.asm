.data
pregunta: .asciiz "¿Cual es tu nombre? "
saludo:	  .ascii "Hola "
nombre:   .space 20
	  .asciiz ""
	  
.text

main:  
	#Imprime la pregunta
	la $a0 pregunta
	li $v0 4
	syscall
	
	li $v0 8
	la $a0 nombre
	li $a1 19
	syscall

	la $a0 saludo
	li $v0 4
	syscall

end:
	li $v0 10
	syscall
	