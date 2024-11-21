extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ScriptGlobal.qtd_vidas==1):
		$AnimationPlayer.play("uma_vida")
	elif (ScriptGlobal.qtd_vidas==2):
		$AnimationPlayer.play("duas_vidas")
	elif (ScriptGlobal.qtd_vidas==3):
		$AnimationPlayer.play("tres_vidas")
	elif (ScriptGlobal.qtd_vidas==4):	
		$AnimationPlayer.play("quatros_vidas")
		
		
	if(ScriptGlobal.qtd_vidas == 0):
		get_tree().change_scene("res://cena_game_over.tscn")	
	
		
		
