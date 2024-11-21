extends KinematicBody2D

# Variáveis para movimento
var velocidade = 700  # Velocidade do inimigo
var direcao = 1  # Direção: 1 para a direita, -1 para a esquerda
var gravidade = 30  # Força da gravidade
var mov = Vector2.ZERO  # Vetor de movimento

# Controle do tempo
var tempo_para_mudar = 1.8  # Tempo em segundos antes de mudar de direção
var tempo_acumulado = 0.0  # Tempo acumulado desde o último movimento

# Pulinho
var pulinho_forca = -400  # Força do pulo (negativo para subir)
var tempo_pulinho = 0.2  # Tempo de duração do pulo
var pulando = false  # Flag para controlar o pulo
var tempo_pulinho_acumulado = 0.0  # Tempo acumulado do pulo

func _physics_process(delta):
	# Aplica gravidade
	mov.y += gravidade
	
	# Acumula o tempo decorrido
	tempo_acumulado += delta
	
	# Verifica se é hora de mudar a direção
	if tempo_acumulado >= tempo_para_mudar:
		direcao *= -1  # Inverte a direção
		tempo_acumulado = 0.0  # Reseta o tempo acumulado
		
		# Aciona o pulinho
		pulando = true
		tempo_pulinho_acumulado = 0.0  # Reseta o tempo do pulinho
	
	# Verifica se o boss está pulando
	if pulando:
		# Aplica o movimento de pulo
		mov.y = pulinho_forca
		tempo_pulinho_acumulado += delta
		
		# Se o pulo terminar, volta à gravidade
		if tempo_pulinho_acumulado >= tempo_pulinho:
			pulando = false
			mov.y = 0  # Para de aplicar o pulo
	
	# Define o movimento horizontal
	mov.x = velocidade * direcao
	
	# Movimenta o inimigo com deslizamento (gravitacional)
	mov = move_and_slide(mov, Vector2.UP)
	
	# Atualiza a orientação do sprite
	atualizar_sprite()

func atualizar_sprite():
	# Inverte o sprite com base na direção
	if direcao == -1:
		$Sprite.flip_h = false  # Direção para a direita
	elif direcao == 1:
		$Sprite.flip_h = true  # Direção para a esquerda

func causar_dano(body):
	if body.name == "Jogador":
		# Toca a animação de dano no jogador
		body.get_node("AnimationPlayer").play("dano")
		# Reduz o número de vidas
		ScriptGlobal.qtd_vidas -= 1
		
		# Muda a direção imediatamente ao causar dano
		direcao *= -1  # Inverte a direção ao dar dano
		tempo_acumulado = 0.0  # Reseta o contador de tempo para começar o novo ciclo de direção
		
		# Aciona o pulinho
		pulando = true
		tempo_pulinho_acumulado = 0.0
