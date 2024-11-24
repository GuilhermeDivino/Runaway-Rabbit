extends Area2D

func _on_door_body_entered(body):
	if body.name == "Jogador": # Substitua "Jogador" pelo nome exato do seu nó de jogador
		print("jogador está na porta")
		get_tree().change_scene("res://fase_2.tscn") # Substitua pelo caminho da sua cena da fase 2
