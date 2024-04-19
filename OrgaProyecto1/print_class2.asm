# Este codigo tiene como objetivo imprimir en la terminal la clase pedida con formato (VERSION 2)

# Estos datos son para poder probar el codigo
.data 

	#  Campos =  Dir del nodo anterior | dia | hora | codig0 |salon | nombre |T/L | dir del sig nodo
	dir_node: .word 0, 1, 0, 0, 0, 0, 0, 0   
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
	tiempo_libre:  .asciiz "Tiempo libre"
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

.macro push ( %r )
	sw   %r ($sp)
	addi $sp $sp 4
.end_macro

.macro pop ( %r )
	subi $sp $sp 4
	lw   %r ($sp)
.end_macro

 .text
 
 ######################################################################
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
 ######################################################################
 
 li $s7, 40
 
 la $a1, dir_node
 li $a2, 1
 
 
 print:
 	# Suposiciones:
 	#	$a1: contienen la direccion de un nodo en el heap
 	#	$a2: contiene 1 si hay que imprimir una caja de "tiempo libre", 0 de lo contrario
 	
 	push ( $s0 ) 				# Como vamos a usar s0 necesitamos guardar lo que tenga pra no perderlo
 	push ($s1)
 	push ($s2)
  	move $s0, $a1
 	
 print_ft: beqz $a2, print_class
 
 # La unica forma de caer en una caja del tipo tiempo libre es haberse movido horizontalmente y no haber encontrado
# una clase con el mismo horario
# LINEA 0
 	li $a0, 45				# Cargamos el ascii del caracter a imprimir, en este caso es "-"
 	move $a1, $s7
 	jal print_chain 			# Imprimimos la cadena de guiones
 	
 	la $a0, salto
	jal print_string			# imprimimos un salto de linea
 	
 	# LINEA 1
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	jal print_char 				# imprimirmos un espacio
	
	add $s0, $s0, 4				# Nos movemos al campo del dia
	lw  $a1, ($s0)
	jal choose_day_print 			# buscamos la direccion del dia a imprimir
	move $s1, $v1				#guardamos la direccion de dia
	
	move $a1, $v1
	li   $a2,  10
	jal calcular_espacio			# Aprovechamos para calcular el espacio dado que el dia lo va a afectar
	move $s2, $v1
	
	move $a0, $s1
	jal print_string 			# imprimimos el dia
	
	li $a0, 32
	jal print_char 				# imprimirmos un espacio
	
	add $s0, $s0, 4				# Nos movemos al campo del horario
	lw  $a1, ($s0)
	li  $a2, 2
	jal print_n_chars 			# Imprimimos la primera hora del horario
	
	li $a0, 45
	jal print_char				# imprimirmos un guion
	
	lw  $a1, ($s0)
	li  $a2, 2
	jal print_n_chars 			# Imprimimos de nuevo la primera hora del horario

	li   $a0, 32
	move $a1, $s2
	jal print_chain				# imprimimos la candidad de espacios calculadas
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 94
	jal print_char 				# imprimirmos "^"
	
	la $a0, salto
	jal print_string			# imprimimos un salto de linea
	
	# LINEA 2
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	sub $a1, $s7, 3
	jal print_chain				# imprimimos el espacio
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 87
	jal print_char 				# imprimirmos "w"
	
	la $a0, salto
	jal print_string			# imprimimos un salto de linea
	
	# LINEA 3
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	jal print_char 
	
	la $a0, tiempo_libre
 	jal print_string
 	
 	li $a0, 32
	sub $a1, $s7, 16
	jal print_chain				# imprimimos el espacio
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 83
	jal print_char 				# imprimirmos "S"
	
	la $a0, salto
	jal print_string			# imprimimos un salto de linea
	
	# LINEA 4
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	sub $a1, $s7, 3
	jal print_chain				# imprimimos el espacio
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 118
	jal print_char 				# imprimirmos 'v'
	
	la $a0, salto
	jal print_string
	
	#LINEA 5
	li $a0, 45				
 	move $a1, $s7
	jal print_chain				#imprimimos la segunda cadena de "-"
	
	la $a0, salto
	jal print_string
	
	#LINEA 6
	la $a0, menu_abajo
	jal print_string
 
 	b end_print				
 
 print_class: 
 	# LINEA 0
 	li $a0, 45				# Cargamos el ascii del caracter a imprimir, en este caso es "-"
 	move $a1, $s7
 	jal print_chain 			# Imprimimos la cadena de guiones
 	
 	la $a0, salto
	jal print_string			# imprimimos un salto de linea
 	
 	# LINEA 1
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	jal print_char 				# imprimirmos un espacio
	
	add $s0, $s0, 4				# Nos movemos al campo del dia
	lw  $a1, ($s0)
	jal choose_day_print 			# buscamos la direccion del dia a imprimir
	move $s1, $v1				#guardamos la direccion de dia
	
	move $a1, $v1
	li   $a2,  10
	jal calcular_espacio			# Aprovechamos para calcular el espacio dado que el dia lo va a afectar
	move $s2, $v1
	
	move $a0, $s1
	jal print_string 			# imprimimos el dia
	
	li $a0, 32
	jal print_char 				# imprimirmos un espacio
	
	add $s0, $s0, 4				# Nos movemos al campo del horario
	lw  $a1, ($s0)
	li  $a2, 2
	jal print_n_chars 			# Imprimimos la primera hora del horario
	
	li $a0, 45
	jal print_char				# imprimirmos un guion
	
	lw  $a1, ($s0)
	add $a1, $a1, 2
	li  $a2, 2
	jal print_n_chars 			# imprimimos la segunda hora del horario
	
	li $a0, 32
	move $a1, $s2
	jal print_chain				# imprimimos la candidad de espacios calculadas
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 94
	jal print_char 				# imprimirmos "^"
	
	la $a0, salto
	jal print_string			# imprimimos un salto de linea
	
	# LINEA 2
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	sub $a1, $s7, 3
	jal print_chain				# imprimimos el espacio
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 87
	jal print_char 				# imprimirmos "w"
	
	la $a0, salto
	jal print_string			# imprimimos un salto de linea
	
	# LINEA 3
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	jal print_char 				# imprimirmos un espacio
	
	add $s0, $s0, 4
	lw  $a1, ($s0)
	li  $a2, 8
	jal print_n_chars 			#Imprimimos el codigo mas un espacio
	
	add $s0, $s0, 8
	lw  $a0, ($s0)
	jal print_string                       #Imprimimos el nombre de la materia
	
	lw   $a1, ($s0)
	li   $a2,  12
	jal calcular_espacio	
	
	li  $a0, 32
	move $a1, $v1
	jal print_chain				# imprimimos la candidad de espacios calculadas
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 83
	jal print_char 				# imprimirmos "S"
	
	la $a0, salto
	jal print_string			# imprimimos un salto de linea
	
	# LINEA 4
	li $a0, 124
	jal print_char 				# imprimirmos la primera barra de la linea
	
	li $a0, 32
	jal print_char 				# imprimirmos un espacio
	
	sub $s0, $s0, 4
	lw  $a1, ($s0)
	li  $a2, 8
	jal print_n_chars			# imprimimos el salon 
	
	add $s0, $s0, 8
	lb  $a1, ($s0)
	jal teoria_o_lab			# cargamos la direccion que corresponda
	jal print_string			# imprimimos el resultado
	
	move $a1, $a0
	li   $a2,  12
	jal calcular_espacio
	
	li  $a0, 32
	move $a1, $v1
	jal print_chain				# imprimimos la candidad de espacios calculadas
	
	li $a0, 124
	jal print_char 				# imprimirmos la segunda barra de la linea
	
	li $a0, 118
	jal print_char 				# imprimirmos 'v'
	
	la $a0, salto
	jal print_string
	
	#LINEA 5
	li $a0, 45				
 	move $a1, $s7
	jal print_chain				#imprimimos la segunda cadena de "-"
	
	la $a0, salto
	jal print_string
	
	#LINEA 6
	la $a0, menu_abajo
	jal print_string
 
 	b end_print
 	
print_chain:
	# Recibe:
	#	$a0: codigo ascii del char a imprimir 
	#	$a1: la cantidad de veces a imprimir
	
	push ( $ra )					# Esta funcion contiene llamadas a otras funciones
	
	print_chain_loop: beqz $a1, end_print_chain
		jal print_char	
		sub $a1, $a1, 1	
	b print_chain_loop
	
end_print_chain:
	pop ( $ra )
	jr $ra

	
print_char:
	# Recibe:
	#      $a0: el codigo ascii que representa el caracter a imprimir
	
	li $v0, 11
	syscall
	jr $ra
	
print_string: 
	# Recibe:
	#      $a0: la direccion en memoria que apunto a la cadena de caracteres a imprimir
	
 	li $v0, 4 
	syscall 
	jr $ra
	
choose_day_print:
	# Recibe:
	# 	a1: numero asociado al dia de la semana
	# Devuelve:
	# 	$v1: la direccion en memoria del string del dia a imprimir
	
	print_lunes: bne $a1, 0, print_martes
	la $v1, lunes
	jr $ra
	
	print_martes: bne $a1, 1, print_miercoles
	la $v1, martes
	jr $ra
	
	print_miercoles: bne $a1, 2, print_jueves
	la $v1, miercoles
	jr $ra
	
	print_jueves: bne $a1, 3, print_viernes
	la $v1, jueves
	jr $ra
	
	print_viernes: bne $a1, 4, print_sabado
	la $v1, viernes
	jr $ra
	
	print_sabado: bne $a1, 5, error
	la $v1, viernes
	jr $ra
	
	error: 
	li $v1, -1
	jr $ra 

print_n_chars:
	# Recibe:
	# 	$a1: direccion en donde comenzar a imprimir cada caracter
	# 	$a2: la cantidad de caracteres que se quiere imprimir
	push ($ra)
	print_n_chars_loop: beqz $a2, end_print_n_chars
		lb $a0, ($a1)
		jal print_char
		add $a1, $a1, 1
		sub $a2, $a2, 1
	b print_n_chars_loop
	
end_print_n_chars:
		pop ($ra)
		jr $ra

calcular_espacio:
	# Recibe
	#	$a1: la direccion de una cadena que afecta el calculo del espacio
	#	$a2: numero de cosas fijas a imprimir
	# Devuelve:
	#	$v1: el espacio a imprimir antes de cerrar la caja
	
	move $t0, $s7				# Recuperamos el tam de la caja
	sub  $t0, $t0, $a2			# Restamos la cantidad de caracteres fija
	
	lb  $t1, ($a1)				# cargaremos el primer caracter
calcular_espacio_loop:  beq $t1, 0, end_calcular_espacio
	sub $t0, $t0, 1
	add $a1, $a1, 1
	lb  $t1, ($a1)
b calcular_espacio_loop

end_calcular_espacio:
	move $v1, $t0
	jr $ra
	
teoria_o_lab:
	# Recibe
	# a1 la direccion del byte a revisar
	bne $a1, 76, t
	la $a0, lab
	jr $ra
	
	t: 
	la $a0, teoria
	jr $ra
	
	
 end_print:
 	pop ($s2)
 	pop ($s1)
 	pop( $s0 )
