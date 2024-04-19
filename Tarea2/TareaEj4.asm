# Tarea 2. Ejercicio 4	(Version 1. Con la formula cerrada)
#
# Calcule del modo más eficiente posible (en menos instrucciones) la suma de los primeros k números naturales.
#
# Nota: Se realizo otro archivo donde en vez de resolverse por medio de la formula cerrada
#	se resuelve por medio de un bucle (Se encoentra en el archivo TareaEj4VerAlt.asm). 
#	En la comparación, esta solución resultó en menos instrucciones (Y claramente es 
#	mucho más rápida y eficiente).
#
# Sandibel Soares
# 1710614

 .data 
 	K: .word 10
 
 .text
 
main:
	lw $t0, K		
	add $t1, $t0, 1		# k + 1
	mul $t1, $t0, $t1	# k((k+1)
	div $t1, $t1, 2		# k((k+1)/2	El resultado de la suma de los primeros k numeros naturales

print:
	move $a0, $t1
	li $v0, 1
	syscall 
 
end: 
 	li $v0, 10
 	syscall 
