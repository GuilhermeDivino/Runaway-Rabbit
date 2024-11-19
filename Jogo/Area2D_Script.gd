extends Area2D

func _ready():
	# Conectar o sinal body_entered para detectar quando o jogador colidir com o limite
	connect("body_entered", self, "_on_body_entered")

# Função chamada quando um corpo entra na área do Limite_do_mapa
func _on_body_entered(body):
	if body.name == "jogador":  # Verifica se o corpo colidido é o jogador
		print("Personagem colidiu com o limite do mapa!")
		get_tree().reload_current_scene()  # Reinicia a fase
