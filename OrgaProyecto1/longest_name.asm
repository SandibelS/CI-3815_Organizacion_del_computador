# En este archivo se calcula cual nombre de las materias en el horario es el mas largo y se guarda la cantidad
# de caracteres

#.data
#	C1N: .asciiz "CI-2613 MEM-008 Algoritmos III"
#	C2N: .asciiz "CI-2693 MYS-019 Lab. Algoritmos III"
#	C3N: .asciiz "CI-3815 TDD-000 Organizacion del Computador"
#	C4N: .asciiz "CO-3121 MEM-005 Probabilidad"
#	C5N: .asciiz "FLX-418 AUL-011 El Razonamiento Logico"
#	C6N: .asciiz "---------"
#	C7N: .asciiz "---------"
#	C8N: .asciiz "---------"

# Este codigo se puede mejorar 

#.text

.macro longest_name


	li  $t0, 0	# la cantidad maxima de caracteres encontrada en un nombre
	
	la  $a1, C1N
	
	lb  $t1, ($a1)
	beq $t1, 45, revisar_clase2
	
	add $a1, $a1, 16
	jal char_count
	
	bge  $t0, $v1, revisar_clase2
	move $t0, $v1

revisar_clase2:

	la  $a1, C2N
	
	lb  $t1, ($a1)
	beq $t1, 45, revisar_clase3
	
	add $a1, $a1, 16
	jal char_count
	
	bge $t0, $v1, revisar_clase3
	move $t0, $v1

revisar_clase3:

	la  $a1, C3N
	
	lb  $t1, ($a1)
	beq $t1, 45, revisar_clase4
	
	add $a1, $a1, 16
	jal char_count
	
	bge $t0, $v1, revisar_clase4
	move $t0, $v1

revisar_clase4:

	la  $a1, C4N
	
	lb  $t1, ($a1)
	beq $t1, 45, revisar_clase5
	
	add $a1, $a1, 16
	jal char_count
	
	
	bge $t0, $v1, revisar_clase5
	move $t0, $v1

revisar_clase5:

	la  $a1, C5N
	
	lb  $t1, ($a1)
	beq $t1, 45, revisar_clase6
	
	add $a1, $a1, 16
	jal char_count
	
	bge $t0, $v1, revisar_clase6
	move $t0, $v1

revisar_clase6:

	la  $a1, C6N
	
	lb  $t1, ($a1)
	beq $t1, 45, revisar_clase7
	
	add $a1, $a1, 16
	jal char_count
	
	bge $t0, $v1, revisar_clase7
	move $t0, $v1

revisar_clase7:

	la  $a1, C7N
		
	lb  $t1, ($a1)
	beq $t1, 45, revisar_clase8
	
	add $a1, $a1, 16
	jal char_count
	
	bge $t0, $v1, revisar_clase8
	move $t0, $v1

revisar_clase8:

	la  $a1, C8N
	
	lb  $t1, ($a1)
	beq $t1, 45, end_longest_name
	
	add $a1, $a1, 16
	jal char_count
	
	bge $t0, $v1, end_longest_name
	move $t0, $v1		

char_count:
	# Recibe:
	#	a1: la direccion donde comienza la cadena de caracteres
	# Devuelve:
	#	v1: la cantidad de caracteres de la cadena antes de encontrase con un 0
	
	lb  $t1, ($a1) # cargaremos un caracter a la vez
	li  $t2, 0	# Nuestro contador
longest_name_loop:  beq $t1, 0, end_lgs_nm_loop	
	add $t2, $t2, 1
	add $a1, $a1, 1
	lb  $t1 , ($a1)
b longest_name_loop

end_lgs_nm_loop:
	move $v1, $t2
	jr $ra
	
end_longest_name:
	move $s5, $t0		# En s5 se guardaremos la cantidad de caracteres del nombre mas largo

.end_macro
