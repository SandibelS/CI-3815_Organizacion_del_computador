# Este codigo tiene como objetivo imprimir en la terminal la clase pedida con formato


# Estos datos son para poder probar el codigo
.data 

	# Nodo, (hay que llenarlo con las direcciones corresp)
	dir_node: .word 0 #Dir del nodo anterior
		  .word 1 #(Martes)
		  .word 0 #hora
		  .word 0 #codigo
		  .word 0 #salon
		  .word 0 #nombre
		  .word 0 #T/L
		  .word 0 #dir del sig nodo
		  
	# Datos para el nodo
	C1N: .asciiz "CI-2613 MEM-008 Algoritmos III"
	C1H: .ascii "-0000T0304-0000T0304-0000-0000"
	
	# caracteres necesarios para imprimir y dias de la semana
	
	guion: .asciiz "-"
	barra: .asciiz "| "
	menu_abajo: .asciiz " <- A | D -> | X"
	menu_der_sig1: .asciiz "^"
	menu_der_W: .asciiz "W"
	menu_der_S: .asciiz "S"
	menu_der_sig2: .asciiz "v"
	timpo_libre:  .asciiz "Tiempo libre"
	salto: .asciiz "\n"
	tab: .asciiz "\t"
	espacio: .asciiz " "  #Podria usar el codigo ascii para muchas cosas aqui
	
	# Es posible que necesites emparejar los dias con la cantidad de caracteres para poder
	# calcular el espacio
	lunes:  .asciiz "Lunes"
	martes: .asciiz "Martes"
	miercoles: .asciiz "Miercoles"
	jueves: .asciiz "Jueves"
	viernes: .asciiz "Viernes"
	sabado: .asciiz "Sabado"
	
	teoria: .asciiz "Teoria"
	lab: .asciiz "Laboratorio"
	
	# Necesitamos una varaible global que nos diga cual es el nombre con tamaño maximo
	# de forma que podamos decidir el tamaño de la caja. supongamos que ya lo tenemos
	# 1 + 7 + 1 + 14 + 4 + 2(espacio + codigo + espacio + nombreMasLargo + tab + | + menu vertical)
	tam_caja: .word 27
	
	nueva_palabra: .space 7
	

 .text
 #Iniciamos nuestro nodo, esto no va en el codigo, es solo para probar
 la $t0, dir_node 
 la $t1, C1N
 la $t2, C1H
 
 #hora
 add $t0, $t0, 8
 add $t2, $t2, 6
 sw  $t2, ($t0)
 
 #codigo
 add $t0, $t0, 4
 sw  $t1, ($t0)
 
 #salon
 add $t0, $t0, 4
 add $t1, $t1, 8
 sw  $t1, ($t0)
 
 #nombre
 add $t0, $t0, 4
 add $t1, $t1, 8
 sw  $t1, ($t0)
 
 #T/L
 add $t0, $t0, 4
 sub $t2, $t2, 1
 sw  $t2, ($t0)
 ###########################################
 
main: 	 la $a1, dir_node   # supongamos que estamos pasando la direccion del nodo por $a1
 	 li $a2, 0	    # Cuando vayamos a imprimir un nodo vamos a especificar si en realidad no encontramos nada y vamos a poner 
 	 	   	    # "tiempo libre". Esto lo vamos a especificar por medio de un argumento
		 	   	  
#tenemos que guardar s0 y s1 en el stack // s1 no, no necesitas guardar lo que hay en a2
move $s0, $a1
	 	    	 	    	 	   
 			# Revisamos si tenemos que crear una caja del tipo "tiempo libre"
bnez $a2, print_class  #Si no es el caso, nos vamos a imprimir la clase
# La unica forma de caer en una caja del tipo tiempo libre es haberse movido horizontalmente y no haber encontrado
# una clase con el mismo horario
# Seria bueno pasar el nodo anterior porque asi podriamos saber en que hora estabamos 

 	 	   
print_class:
	jal print_chain #imprimimos la cadena
	
	# LINEA 1
	la $a0, barra
	jal print_string # imprimirmos la primera barra de la linea
	
	add $s0, $s0, 4
	lw  $a1, ($s0)
	jal choose_day 	# buscamos la direccion del dia 
	
	move $a0, $v1
	jal print_string # imprimimos el dia
	
	la $a0, espacio
	jal print_string # imprimirmos un espacio
	
	add $s0, $s0, 4
	lw  $a1, ($s0)
	li $a2, 2
	jal print_n_chars #imprimimos la primera hora del horario
	
	la $a0, guion
	jal print_string # imprimirmos un guion
	
	lw  $a1, ($s0)
	add $a1, $a1, 2
	li $a2, 2
	jal print_n_chars #imprimimos la segunda hora del horario

	#jal calcular_espacio
	
	la $a0, salto
	jal print_string #imprimimos un salto de linea
	
	# LINEA 2
	la $a0, barra
	jal print_string # imprimirmos la primera barra de la linea
	
	#jal calcular_espacio
		
	la $a0, salto
	jal print_string
	
	# LINEA 3
	la $a0, barra
	jal print_string # imprimirmos la primera barra de la linea
	
	add $s0, $s0, 4
	lw $a1, ($s0)
	li $a2, 7
	jal print_n_chars #Imprimimos el codigo
	
	la $a0, espacio
	jal print_string # imprimirmos un espacio
	
	add $s0, $s0, 8
	lw $a0, ($s0)
	jal print_string #Imprimimos el nombre de la materia
	
	la $a0, salto
	jal print_string
	
	#LINEA 4
	la $a0, barra
	jal print_string
	
	sub $s0, $s0, 4
	lw $a1, ($s0)
	li $a2, 8
	jal print_n_chars
	
	
	add $s0, $s0, 8
	lb $a1, ($s0)
	jal teoria_o_lab
	jal print_string
	
	la $a0, salto
	jal print_string
	
	jal print_chain #imprimimos la segunda cadena de "-"

	la $a0, menu_abajo
	jal print_string
	
	b end
		    	   
print_chain:
	lw $t0, tam_caja	#ojo
	la $a0, guion
	
	# Empila ra
	sw $ra ($sp)
	addi $sp $sp 4

	print_chain_loop: beqz $t0, end_print_chain

		jal print_string	
		sub $t0, $t0, 1	

	b print_chain_loop
	
end_print_chain:
	la $a0, salto
	jal print_string
	
	# Desempila $ra
	subi $sp $sp 4
	lw $ra ($sp)
	 
	jr $ra
	#b end
	
print_n_chars:
	# en $a1 debe estar la direccion en donde comenzar
	# en $a2 debe estar la cantidad de char que se quiere imprimir
	la $t0, nueva_palabra
	
	# Empila ra
	sw $ra ($sp)
	addi $sp $sp 4
	
	print_n_chars_loop: beqz $a2, end_print_n_chars
	
		lb $t1, ($a1)
		sb $t1, ($t0)
		 
		add $a1, $a1, 1
		add $t0, $t0, 1

		sub $a2, $a2, 1
		
	b print_n_chars_loop
	
end_print_n_chars:
	la $a0, nueva_palabra
	jal print_string
	
	# Desempila $ra
	subi $sp $sp 4
	lw $ra ($sp)
	 
	jr $ra

print_string: #tal vez deberia llamarlo "llamar a imprimir" o algo asi?
 	li $v0, 4 #tal vez no sea necesario?
	syscall 
	jr $ra

choose_day:
	# en a1 debe estar el numero asociado al dia de la semana
	# en $v1 estara el adress del string del dia para imprimir
	
	es_lunes: bne $a1, 0, es_martes
	la $v1, lunes
	jr $ra
	
	es_martes: bne $a1, 1, es_miercoles
	la $v1, martes
	jr $ra
	
	es_miercoles: bne $a1, 2, es_jueves
	la $v1, miercoles
	jr $ra
	
	es_jueves: bne $a1, 3, es_viernes
	la $v1, jueves
	jr $ra
	
	es_viernes: bne $a1, 4, es_sabado
	la $v1, viernes
	jr $ra
	
	es_sabado: bne $a1, 5, error
	la $v1, viernes
	jr $ra
	
	error: 
	li $v1, -1
	jr $ra 

#calcular_espacio:
 

teoria_o_lab:
# a1 la direccion del byte a revisar
	bne $a1, 76, t
	la $a0, lab
	jr $ra
	
	t: 
	la $a0, teoria
	jr $ra
	
end: 	   	 	  	 	    	 	   	 	   	 	    	 	   	 	   	 	  	 	    	 	   	 	      	 	   	 	   	 	  	 	    	 	   	 	   	 	    	 	   	 	   	 	  	 	    	 	   	 	   	    	 	   	 	   	 	  	 	    	 	   	 	   	 	    	 	   	 	   	 	  	 	    	 	   	 	   	    	 	   	 	   	 	  	 	    	 	   	 	   	 	    	 	   	 	   	 	  	 	    	 	   	 	   
