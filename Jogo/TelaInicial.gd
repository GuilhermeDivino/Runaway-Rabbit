extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	pass # Replace with function body.
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Fase_1.tscn")
	


func _on_btnCredits_pressed():
	get_tree().change_scene("res://TelaCreditos.tscn")


func _on_btnQuit_pressed():
	get_tree().quit()
