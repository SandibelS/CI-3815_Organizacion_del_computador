# En este archivo se encuentra el procedimiento para agregar un nodo a la lista enlazada que se especifique.
#
# Para agregar un nodo a una lista, primero se busca en que posicion de lista debe ir en base al horario 
# en dicho nodo.

.macro add_node (%DirNode %DirHead)

	# A continuacion hay una idea de como implementar el procedimiento (Enfasis en "idea")

 	# Usando DirNode, obtenemos el apuntador en donde comienza los caracteres del horario.
 	
 	# Procesamos los caracteres para saber en que bloque estamos (1-2, 3-4, ...) 
 	 
 	# Cargamos la direccion que haya en DirHead
 	
 		# Si aun no tiene una direccion, significa que la lista enlazada esta vacia 
 		# y simplemento guardamos DirNode en la cabeza
 		
 		# Si la lista no esta vacia, debemos usar las direcciones de la lista hasta encontrarnos 
 		# con alguna de las siguientes situaciones:
 		#   (1) Encontramos un nodo con el mismo horario que nuestro nodo (Un choque de materia!), por lo que 
 		#	agregamos el nodo en esa posicion (y pensamos luego que hacer con el choque)
 		#   (2) Encontramos un nodo con un bloque mayor al nuestro (Por ejemplo, encontramos una clase 3-4
 		# 	y nuestro nodo tiene como horario 1-2), agregamos nuestro nodo antes de esa clase.
 		#   (3) Llegamos al final de la lista, por lo que lo agregamos a la cola. 

.end_macro