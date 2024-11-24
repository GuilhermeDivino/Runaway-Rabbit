extends Area2D

# Quantidade de hits necessários para a área desaparecer
var max_hits = 20
var current_hits = 0

func _on_hitbox_area_entered(area):
	if area.is_in_group("bullets"):
		# Remove o projétil ao colidir
		area.queue_free()

		# Incrementa o contador de hits
		current_hits += 1

		# Verifica se atingiu o número máximo de hits
		if current_hits >= max_hits:
			owner.queue_free()  # Remove o objeto principal
			print("Objeto destruído!")
		else:
			print("Acertou na mosca! Hits restantes: %d" % (max_hits - current_hits))
