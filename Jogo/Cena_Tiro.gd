extends KinematicBody2D  # Ajustado para usar KinematicBody2D, que facilita o movimento com colisões

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
	# Move o projétil usando física e detecta colisões
	var collision = move_and_collide(velocity * delta)
	
	# Se o projétil colidir, trata a colisão
	if collision:
		_on_collision(collision)

	# Atualiza o timer e remove o projétil se o tempo de vida expirar
	timer -= delta
	if timer <= 0:
		queue_free()

func _update_sprite_direction():
	# Ajusta o sprite para inverter conforme a direção
	if direction.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

# Função para tratar a colisão
func _on_collision(collision):
	var body = collision.get_collider()
	
	# Verifica se o objeto colidido é um inimigo
	if body.name == "Inimigo":
		body.get_node("AnimationPlayer").play("morto")  # Reproduz animação de morte
		body.velocidade = 0  # Para o movimento do inimigo
		body.queue_free()  # Remove o inimigo da cena
		queue_free()  # Remove o projétil

	# Verifica se o objeto colidido é o Boss
	elif body.name == "Boss_Cenoura":
		if body.has_method("take_damage"):
			body.take_damage(1)  # Aplica 1 de dano ao Boss
		queue_free()  # Remove o projétil após a colisão


func _on_Area2D_body_entered(body):
	pass # Replace with function body.
