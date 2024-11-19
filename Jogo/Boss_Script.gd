extends KinematicBody2D

# Variáveis para movimento
var speed = 50  # Velocidade do movimento vertical
var direction = 1  # 1 para baixo, -1 para cima
var bounds = Vector2(20, 220)  # Limites do movimento vertical

# Variáveis para disparo
var projectile_scene = preload("res://Disparo_Boss.tscn")  # Caminho para o projétil
var fire_rate = 1.5  # Intervalo entre disparos (em segundos)
var fire_timer = 0.0  # Contador interno para o próximo disparo

# Variáveis de vida
var health = 20  # Número de hits necessários para destruir o boss

func _physics_process(delta):
	# Movimento vertical
	position.y += direction * speed * delta

	# Verifica os limites
	if position.y >= bounds.y:
		direction = -1  # Inverte para subir
	elif position.y <= bounds.x:
		direction = 1  # Inverte para descer

	# Controle do disparo
	fire_timer -= delta
	if fire_timer <= 0:
		fire_timer = fire_rate  # Reseta o contador
		shoot_projectile()  # Dispara o projétil

func shoot_projectile():
	var projectile = projectile_scene.instance()
	if projectile:
		# Ajusta a posição inicial do projétil para um pouco acima do boss
		projectile.position = position + Vector2(-25, -35)  # Ajusta -20 no eixo Y (para cima)
		get_parent().add_child(projectile)

func _on_Hitbox_area_entered(area):
	# Reduz a vida do boss quando um projétil do jogador o atinge
	if area.name == "Cena_Tiro":  # Verifica o nome da cena do disparo do jogador
		health -= 1
		area.queue_free()  # Remove o projétil do jogador
		if health <= 0:
			queue_free()  # Remove o boss quando a vida chega a zero
