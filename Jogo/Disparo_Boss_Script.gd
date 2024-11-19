extends KinematicBody2D

var speed = 200  # Velocidade do projétil
var lifetime = 2.0  # Tempo de vida do projétil (em segundos)
var time_alive = 0.0  # Contador para o tempo de vida do projétil

func _ready():
	if $Sprite:
		$Sprite.scale.x = -abs($Sprite.scale.x)  # Inverte o sprite para indicar direção

func _physics_process(delta):
	# Movimenta o projétil para a esquerda
	position.x -= speed * delta

	# Atualiza o contador de tempo
	time_alive += delta

	# Verifica se o projétil ultrapassou o tempo de vida
	if time_alive >= lifetime:
		queue_free()  # Remove o projétil da cena
