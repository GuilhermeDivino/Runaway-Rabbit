extends KinematicBody2D

var velocity = Vector2.ZERO # Variáveis de movimentação e gravidade
var move_speed = 480
var gravity = 1200
var jump_force = -720
var friction = 0.1 # Suavidade da parada 
var stop_threshold = 50 # Tolerância para parar o movimento
var dash_cooldown = 2.0 # Tempo de cooldown para o dash
var can_dash = true # Controla se o dash pode ser feito
var dash_speed = 1500 # Velocidade do dash
const bullet_scene = preload("res://bullet.tscn")
var is_shooting := false
var dash_timer = 0.0 # Timer para o do dash
onready var bullet_position = $bullet_position	
onready var shoot_cooldown = $shoot_cooldown


func _ready():
	# Aqui pode ser incluído qualquer inicialização necessária
	pass

func _physics_process(delta: float) -> void:
	# Aplica a gravidade continuamente
	velocity.y += gravity * delta

	# Obtém a entrada do jogador para movimentação
	_get_input()

	# Define a animação apropriada
	_set_animation()
	
	if Input.is_action_just_pressed("shoot"):
		is_shooting = true
		shoot_bullet()
	else:
		is_shooting = false
		

	# Se o jogador pressionar a tecla de pulo e o personagem estiver no chão, ele pula
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Move o personagem, detectando colisões com o chão e outros objetos
	velocity = move_and_slide(velocity, Vector2.UP)

	# Atualiza o cooldown do dash
	if not can_dash:
		dash_cooldown -= delta
		if dash_cooldown <= 0:
			can_dash = true

	# Atualiza o timer de dash
	if dash_timer > 0:
		dash_timer -= delta
		_set_animation("Dash") # Força a animação do dash enquanto está acontecendo
		if dash_timer <= 0:
			# Após o tempo do dash, a velocidade retorna ao normal
			velocity.x = lerp(velocity.x, 0, friction)

func _get_input():
	# Calcula a direção de movimento
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		
	# Aplica Lerp para suavizar a transição de velocidade
	velocity.x = lerp(velocity.x, move_speed * move_direction, friction)

	# Inverte o sprite ao se mover para a esquerda ou direita
	if move_direction != 0:
		$Texture.scale.x = abs($Texture.scale.x) * move_direction

	# Realiza o dash se a tecla "dash" for pressionada e se o cooldown permitir
	if Input.is_action_just_pressed("dash") and can_dash:
		_dash()
		can_dash = false
		dash_cooldown = 2.0 # Define o cooldown após o dash
		
	if Input.is_action_pressed("move_left"):
		if sign(bullet_position.position.x) == 1:
			bullet_position.position.x *= -1
			
	if Input.is_action_pressed("move_right"):
		if sign(bullet_position.position.x) == -1:
			bullet_position.position.x *= -1
		
		
		
func _set_animation(anim_name: String = ""):
	# Se nenhuma animação foi passada, determina a animação com base na lógica de movimento
	if anim_name == "":
		anim_name = "idle"
		
		# Se o personagem está no ar a animação de pulo ocorre
		if not is_on_floor():
			anim_name = "Jump"
		# Verifica se a velocidade é maior que o limite minimo para usar a animação de corrida
		elif abs(velocity.x) > stop_threshold:
			anim_name = "Run"
		# Verifica se o dash está ativo
		elif velocity.x == dash_speed or velocity.x == -dash_speed:
			anim_name = "Dash"
			

	# Executa a animação se for diferente da animação atual
	if $Anim.assigned_animation != anim_name:
		$Anim.play(anim_name)

func _dash():
	# Define a velocidade do dash na direção atual do personagem
	velocity.x = dash_speed * sign($Texture.scale.x)
	dash_timer = 0.3 # Define o tempo do dash
	

	
func shoot_bullet():
	var bullet_instance = bullet_scene.instance()
	if sign(bullet_position.position.x) == 1:
		bullet_instance.set_direction(1)
	else: 
		bullet_instance.set_direction(-1)
		
	add_child(bullet_instance)
	bullet_instance.global_position = bullet_position.global_position
	



	




