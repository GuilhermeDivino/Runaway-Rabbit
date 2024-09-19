extends Node2D

# Assumindo que a câmera é um filho do personagem
onready var camera = $Camera2D

func _ready():
	# Define a câmera como a câmera atual
	camera.current = true
	# Configura a câmera para seguir o personagem
	camera.offset = Vector2(0, 0)  # Ajuste o offset se necessário
	camera.smoothing_enabled = true
	camera.smoothing_speed = 5.0  # Ajuste a velocidade de suavização se necessário
