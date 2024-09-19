extends KinematicBody2D

var velocity = Vector2.ZERO # Variáveis de movimentação e gravidade
var move_speed = 480
var gravity = 1200
var jump_force = -720
var friction = 0.1 # Suavidade da parada 
var stop_threshold = 50 # Tolerância para parar o movimento
var projectile_scene : PackedScene # Cena do projétil
var shoot_cooldown = 0.4 # Tempo de cooldown para disparo
var can_shoot = true # Controla se o projétil pode ser disparado
var dash_cooldown = 2.0 # Tempo de cooldown para o dash
var can_dash = true # Controla se o dash pode ser feito
var dash_speed = 1500 # Velocidade do dash
var projectile_speed = 100 # Velocidade do projétil

var shoot_timer = 0.0 # Timer para o disparo
var dash_timer = 0.0 # Timer para o do dash

func _ready():
	# Carrega a cena do projétil
	projectile_scene = preload("res://Cena_Tiro.tscn")

func _physics_process(delta: float) -> void:
	# Aplica a gravidade continuamente
	velocity.y += gravity * delta

	# Obtém a entrada do jogador para movimentação
	_get_input()

	# Define a animação apropriada
	_set_animation()

	# Se o jogador pressionar a tecla de pulo e o personagem estiver no chão, ele pula
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Move o personagem, detectando colisões com o chão e outros objetos
	velocity = move_and_slide(velocity, Vector2.UP)

	# Atualiza o cooldown do disparo
	if not can_shoot:
		shoot_timer -= delta
		if shoot_timer <= 0:
			can_shoot = true

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

	# Dispara o projétil se a tecla "shoot" for pressionada e se o cooldown permitir
	if Input.is_action_pressed("shoot") and can_shoot:
		_shoot_projectile()
		can_shoot = false
		shoot_timer = shoot_cooldown # Define o timer de cooldown após o disparo

	# Realiza o dash se a tecla "dash" for pressionada e se o cooldown permitir
	if Input.is_action_just_pressed("dash") and can_dash:
		_dash()
		can_dash = false
		dash_cooldown = 2.0 # Define o cooldown após o dash

func _shoot_projectile():
	# Instancia a cena do projétil (Cena_Tiro.tscn)
	var projectile = projectile_scene.instance()
	if projectile:
		# Define a posição inicial do projétil mais à frente do personagem
		projectile.position = position + Vector2($Texture.scale.x * 800, -10)

		# Define a direção do projétil
		var direction = Vector2($Texture.scale.x, 0).normalized()
		projectile.velocity = direction * projectile_speed
		projectile.direction = direction # Passa a direção para o projétil
		
		# Adiciona o projétil à cena
		get_parent().add_child(projectile)
	else:
		print("Projetil Bugou :c.")

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
