extends KinematicBody2D

var speed = 1000 # Velocidade do projétil
var direction = Vector2() # Direção do projétil

func _ready():
	# Configuração inicial do projétil
	pass

func _physics_process(delta: float) -> void:
	# Move o projétil na direção especificada
	move_and_slide(direction * speed)
	
	# Remove o projétil quando estiver fora da tela
	if not get_viewport_rect().has_point(position):
		queue_free()
