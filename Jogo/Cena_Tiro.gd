extends Node2D

var velocity = Vector2.ZERO # Velocidade do projétil
var speed = 800 # Velocidade do projétil
var direction = Vector2.RIGHT # Direção inicial do projétil
var lifetime: float = 5.0 # Tempo de vida do projétil
var timer: float = 0.0 # Timer para rastrear o tempo de vida

func _ready():
	# Configura a velocidade do projétil com base na direção
	velocity = direction.normalized() * speed
	_update_sprite_direction()
	
	# Inicializa o timer
	timer = lifetime

func _process(delta: float) -> void:
	# Move o projétil de acordo com a velocidade
	position += velocity * delta

	# Atualiza o timer e remove o projétil se o tempo de vida expirar
	timer -= delta
	if timer <= 0:
		queue_free()
		
	# Remove o projétil se sair da tela (Não funcionou por conta da Camera2D)
	# if not get_viewport().get_visible_rect().has_point(position):
	# 	queue_free()

func _update_sprite_direction():
	# Ajusta o sprite para inverter conforme a direção
	if direction.x < 0:
		$Tiro/Sprite.flip_h = true
	else:
		$Tiro/Sprite.flip_h = false
