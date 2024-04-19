# A partir de dos direcciones que llevan a cadenas de caracteres (Ambas representan un bloque horario, con solo 5 caracteres)
# se indica si el horario de la primera cadena es igual o esta contenido en el horario de la segunda cadena
#
# Ojo, este codigo no te ayuda a posicionar nodos.


# Esta seccion de datos es solo para probar, en teoria este codigo se usa para cadenas que van a estar alojadas
# en diferentes partes de la memoria

# No estoy segura que este codigo este funcionando bien

# hay que guardar en el stack s0, s1, s2, s3
# se modifican los registros: a1, t0, t1, t2, t3 v1
.data 
	dir_str_1: .ascii "01-04"
	dir_str_2: .ascii "01-04"

.text 
	la $a1, dir_str_1
	jal calc_bloque
	move $s0, $t1
	move $s1, $t3
	
	la $a1, dir_str_2
	jal calc_bloque
	move $s2, $t1
	move $s3, $t3
	
	sle $t0, $s2, $s0  #si la primera hora de la segunda clase es mneor o igual que la primera hora de la primera clase
			   # entonces s4 sera 1
			   
	sle $t1, $s1, $s3  # Si la segunda hora de la primera clase es menor o igual que la segunda hora de la segunda clase
			   # entonces s5 sera 1
			   
	and $v1, $t0, $t1 # en v1 estara si la primera clase esta contenida o es igual a la segunda clase 
	
	sle $t0, $s0, $s2  #si la primera hora de la primera clase es mneor o igual que la primera hora de la segunda clase
			   # entonces s4 sera 1
			   
	sle $t1, $s3, $s1  # Si la segunda hora de la segunda clase es menor o igual que la segunda hora de la primera clase
			   # entonces s5 sera 1
	and $t0, $t0, $t1  #sobreescribo $t0 para saber si t0 y t1 son ambos iguales a 1
	
	or $v1, $v1, $t0   #si alguno de lo casos de contencion o igualdad se cumple, entonces dara 1
	
	
	b end
 
 #lb $t0, 1(dir_str_1) #En t0 guardamos el segundo caracater de la primera hora de la primera dir
 #lb $t1, 4(dir_str_1) # ahora el seghndo caracter de la segunda hora

# Revisamos si en los bloques horarios se encuentra alguna de estas horas: 10, 11, 12

calc_bloque:
	lb $t0,  ($a1)
	lb $t1, 1($a1)
	
	beq $t0, 30, segundaHora
	add $t1, $t1, $t0
	
	segundaHora:
	
	lb $t2,  3($a1)
	lb $t3,  4($a1)
	
	beq $t2, 30, fin_calc_bloque
	add $t3, $t3, $t2
	
	fin_calc_bloque:
	jr $ra

end: 
	move $a0, $v1
	li $v0, 1
	syscall
 	