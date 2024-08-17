extends Node2D

@export var dir:Vector2

func _on_area_2d_body_entered(body):
	var balloon = body.get_parent()
	balloon.scalable_dir[dir] = true


func _on_area_2d_body_exited(body):
	var balloon = body.get_parent()
	balloon.scalable_dir[dir] = false
