# Archivo en donde se procesan los datos de las materias,se crean listas enlazadas y los nodos
.include "create_node.asm"
.include "add_node.asm"
.include "p.asm"	#dice p.asm y no *.asm porque tengo un problema con su nombre

	#En las cabezas guardamos la direccion hacia el primer nodo si la lista no esta vacia, 0 de lo contrario
	Head_Lunes: 	.word 0 
	Head_Martes: 	.word 0 
	Head_Miercoles: .word 0
	Head_Jueves: 	.word 0
	Head_Viernes: 	.word 0
	Head_Sabado: 	.word 0

.text

main:	
	la $t0, C1N	# Dir 1era Materia
	la $t1, C1H	# Horario corresp.
	
	# Revisamos que haya una materia (En teoria C1N no deberia necesitar esta revision)
	move $a1, $t0
	jal hayMateria

	# Calculamos la cantidas de clases en base al horario que esta en $t1
	# Asumiendo un maximo de 3 clases a ala semana por materia
	# Por cada clase, creamos un nodo
	
	move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	
	#Calculamos la direccion en donde buscar el horario un poco diferente esta vez
	li   $a1, 5  
	mulo $a1, $s6, $a1
	add  $a1, $a1, 5
	add  $a1, $a1, $t1 
	
	#move $a1, $t1 
	
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat1 #Si no habia otra clase, vamos a la siguiente materia

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat1 #Si no habia otra clase, vamos a la siguiente materia
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat1:
	
	# De aqui en adelante es la misma estructura pero para las otras materias
	
	la $t0, C2N	# Dir 2da Materia
	la $t1, C2H	# Horario corresp.
	
	move $a1, $t0
	jal hayMateria
	
	move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat2 

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat2 
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat2:
	
	##################################################
	
	la $t0, C3N	# Dir 3era Materia
	la $t1, C3H	# Horario corresp.
	move $a1, $t0
	jal hayMateria
	
	move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat3

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat3
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat3:
	
	##################################################
	
	la $t0, C4N	# Dir 4ta Materia
	la $t1, C4H	# Horario corresp.
	
	move $a1, $t0
	jal hayMateria
	
	move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat4 #Si no habia otra clase, vamos a la siguiente materia

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat4 #Si no habia otra clase, vamos a la siguiente materia
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat4:
	##################################################
	
	la $t0, C5N	# Dir 5ta Materia
	la $t1, C5H	# Horario corresp.
	
	move $a1, $t0
	jal hayMateria
	
	move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat5 #Si no habia otra clase, vamos a la siguiente materia

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat5 #Si no habia otra clase, vamos a la siguiente materia
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat5:
	##################################################
	
	la $t0, C6N	# Dir 6ta Materia
	la $t1, C6H	# Horario corresp.
	
	move $a1, $t0
	jal hayMateria
	
	move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat6 #Si no habia otra clase, vamos a la siguiente materia

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat6 #Si no habia otra clase, vamos a la siguiente materia
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat6:
	##################################################
	
	la $t0, C7N	# Dir 6ta Materia
	la $t1, C7H	# Horario corresp.
	
	move $a1, $t0
	jal hayMateria
	
		move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat7 #Si no habia otra clase, vamos a la siguiente materia

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat7 #Si no habia otra clase, vamos a la siguiente materia
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat7:
	##################################################
	
	la $t0, C8N	# Dir 8va Materia
	la $t1, C8H	# Horario corresp.
	
	move $a1, $t0
	jal hayMateria
	
		move $a1, $t1 
	li   $a2,  0
	jal search_L_or_T
	move $s6, $a2 
	
	# Nodo 1 
	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 2 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	move $s6, $a2
	
	beq $a2, 6, finMat8

	create_node ($t0, $a1, $a2) 
	#add_node ()
	
	# Nodo 3 (Si es que hay otra clase)
	move $a1, $t1 
	move $a2, $s6
	jal search_L_or_T
	
	beq $a2, 6, finMat8
	
	create_node ($t0, $a1, $a2) 
	# add_node ()

finMat8:
	
	##################################################
	
end:
	li $v0, 1
	syscall

hayMateria:
	# Recibe: $a1 -> la direccion en donde comienza la linea CiN
	# $a2 tiene 1 si la linea no comienza por "-" (Hay una materia) y 0 de lo contrario
	 
	lb  $a1, 0($a1)
	sne $a2, $a1, 45
	jr $ra

search_L_or_T:
	# Recibe: $a1 -> Direccion en donde se comienza a a buscar el caracter L o T
	#	  $a2 -> el dia en que se comienza a buscar, con esto podemos calcular el valor maximo de iteraciones
	# $a1 -> La direccion donde se encotro el caracter buscado
	# $a2 -> El dia en que encontramos la clase (0: Lunes, 1:Martes, ....)
	
	li  $s0, 6
	sub $s0, $s0, $a2 # en $vo esta la cantidad total de dias menos los que ya revisamos 
	
	# Si llegamos al maximo de iteraciones, no econtramos un horario, lo que seria un error 
	slt_loop: beqz $s0, end_slt_loop
	
		lb  $s1, ($a1)
		bne $s1, 45, end_slt_loop	#Si conseguimos un caracter diferente a "-" tenemos nuestro L o T
		
		add $a1, $a1, 5			#En cambio, si conseguimos un "-" saltamos 5 posiciones adelante
		sub $s0, $s0, 1			#Y en $v0 restamos 1 porque ya revisamos un dia			
	b slt_loop
	
	end_slt_loop: 
			li  $s1, 6
			sub $a2, $s1, $s0	#Calculamos el dia en que estamos. Si es 6, tenemos un error
			jr  $ra	