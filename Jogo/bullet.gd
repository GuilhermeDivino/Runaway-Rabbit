extends Area2D

var bullet_speed := 300.0
var direction := 1

func _process(delta):
	position.x += bullet_speed * direction * delta


func _on_VisibilityEnabler2D_screen_exited():
	queue_free()

func set_direction(dir):
	direction = dir



