# Este archivo tiene como fin intentar realizar un loop que cree los nodos 
# Asumimos que por materia solo pueden haber dos clases de teoria y un lab por semana

.include "create_node.asm"
.data
	#Vamos a intentar primero solo con dos materias
	
	C1N: .asciiz "CI-2613 MEM-008 Algoritmos III"
	C1H: .ascii "-0000T0304-0000T0304-0000-0000"
	
	C2N: .asciiz "CI-2693 MYS-019 Lab. Algoritmos III"
	C2H: .ascii "-0000-0000L0204-0000-0000-0000"
	
	# Suponiendo que hacemos una lista enlazada por dia, necesitamos las cabezas
	# para los dias Martes, Miercoles y Jueves (Para este ejemplo)
	
	Head_Martes: .word 0 #En las cabezas guardamos la direccion hacia el primer nodo si la lista no esta vacia, 0 de lo contrario
	Head_Miercoles: .word 0
	Head_Jueves: .word 0

.text
	la $t0, C1N	# Cargamos la direccion de la primera materia en nuestros datos
	la $t1, C1H	# Tambien el horario conrrespondiente
	li $t2, 3	#

# Revisaremos las entradas en este loop
main_loop: beqz $t2, end

lb $s0, 0($t0)		# Cargamos el primer byte de la direccion de la materia en que estemos para verificarlo
beq $s0, 45, continue 	#Si el byte es igual a 45, es decir, es equivalente al signo "-" saltamos a revisar la siguiente entrada

# Si el byte no era equivalente al signo "-", procedemos a buscar las clases de las materias y por cada clase
# crearemos un nodo el cual agregaremos a lista enlazada correspondiente

move $a0, $t1 
li $a1, 0
jal search_L_or_T_2	#Buscamos la primera clase o Lab

# Creamos el primer nodo
create_node ($t0, $a0, $a1)
#add_node ($v0) # En $v0 esta la dir al nodo en el heap

# Ahora debemos buscar la siguiente clase con search y tenemos que verificar que $a0 no sea mayor que $a1
# Eso significaria que solo habia una clase de la materia en la semana (Como por ejemplo un general)

# creamos el segundo nodo si hay otra clase
# agregamos el segundo nodo

# Hay que buscar otra otra clase o Lab (A partir de que se asume unicamente 2 clases teoricas y un lab, no tendriamos que buscar
# mas luego de este paso)
# Crear el tercer nodo
# Agregar el tercer nodo

# En este punto ya procesamos la materia y creamos los nodos correspondientes
# toca continuar a la siguiente materia si existe

continue:
la $t0, 30($t1) #Nos movemos hasta el final de la entrada del horario, ya que sabemos que luego de esta viene la siguiente materia
# Calcular donde comienza el horario de la siguiente materia es dificl porque no sabemos con exactitud donde termina 
# la linea de la materia, por eso usamos una funcion para contar los caracteres de la linea de la materia y 
# poder inicializar a $t1 con la direccion del siguiente horario.

# Hay que inicializar los argumentos para la funcion cantidad_caracteres: 
# Llamar a cantidad_caracteres

b main_loop

search_L_or_T_2:
	# Recibe: $a0 -> Direccion en donde se comienza a a buscar el caracter L o T
	#	  $a1 -> el dia en que se comienza a buscar, con esto podemos calcular el valor maximo de iteraciones
	# $a0 -> La direccion donde se encotro el caracter buscado
	# $a1 -> El dia en que encontramos la clase (0: Lunes, 1:Martes, ....)
	li $s0, 6
	sub $s0, $s0, $a1 
	slt_loop_2: beqz $s0, end_slt_loop_2
		lb $s1, ($a0)
		bne $s1, 45, end_slt_loop_2	#Si conseguimos un caracter diferente a "-" tenemos nuestro L o T
		add $a0, $a0, 5			#En cambio, si conseguimos un "-" saltamos 5 posiciones adelante
		sub $s0, $s0, 1			#Ya revisamos un dia			
	b slt_loop_2
	end_slt_loop_2: 
			li $s1, 6
			sub $a1, $s1, $s0	#Calculamos el dia en que estamos
			jr $ra
	

cantidad_caracteres: 
	# Falta definir que argumentos recibe, que resultados da (y en donde), y modificar estas lineas en base a eso
	#
	li $s1,  0
	move $s2, $t0
	lb $s3, ($s2)
loop: beqz $s3, print

	add $s2, $s2, 1
	lb $s3, ($s2)
	add $s1, $s1, 1

b loop

# Print fue creado para revisar que "cantidad_caracteres" estuviera funcionando bien, hay que borrarlo 
print:
	move $a0, $t1
	li $v0, 1
	syscall

end:
#	li $v0, 10
#	syscall 
