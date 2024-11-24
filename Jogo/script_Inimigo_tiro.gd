extends KinematicBody2D

# Variáveis para movimento
var velocidade = 100  # Velocidade do inimigo
var direcao = 1  # Direção: 1 para a direita, -1 para a esquerda
var gravidade = 30  # Força da gravidade
var mov = Vector2.ZERO  # Vetor de movimento

# Controle do tempo
var tempo_para_mudar = 3.0  # Tempo em segundos antes de mudar de direção
var tempo_acumulado = 0.0  # Tempo acumulado desde o último movimento

func _physics_process(delta):
	# Aplica gravidade
	mov.y += gravidade
	
	# Acumula o tempo decorrido
	tempo_acumulado += delta
	
	# Verifica se é hora de mudar a direção
	if tempo_acumulado >= tempo_para_mudar:
		direcao *= -1  # Inverte a direção
		tempo_acumulado = 0.0  # Reseta o tempo acumulado
	
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

func causando_dano(body):
	if(body.name=="Jogador"):
		body.get_node("AnimationPlayer").play("dano")
		ScriptGlobal.qtd_vidas -= 1

