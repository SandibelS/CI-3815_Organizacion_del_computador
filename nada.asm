# Revisamos que si el caracter actual es D o L, si no lo es, entonces no hacemos nada
	lb  $t0, caracter_act
	seq $t1, $t0, 100	# revisamos si el caracter es d
	seq $t2, $t0, 108	# revisamos si es l
	or  $t1, $t1, $t2	
	
	beqz $t1, fin_revisar_input	#Si el caracter no era d ni l, terminamos de revisar