# Tarea 2. Ejercicio 4 v2 (Version alternativa. Usando un bucle)
#
# Calcule del modo más eficiente posible (en menos instrucciones) la suma de los primeros k números naturales.

# Nota: Este es solo un archivo con una solucion alternativa en donde se usó un
#	un bucle para comparar con la cantidad de instrucciones necesarias para calcular
#	la suma con la formula cerrada.
#
# Sandibel Soares
# 1710614

.data 
 	K: .word 10
 
.text
 
main:
	lw $t0, K
	li $t1, 0 		# Donde guardamos la suma

loop: beqz $t0, print		# Cuando hayamos sumado los k numeros, imprimimos el resultado

add $t1, $t1, $t0
sub $t0, $t0, 1

bp: b loop

print:
	move $a0, $t1
	li $v0, 1
	syscall 
 
end: 
 	li $v0, 10
 	syscall 
