extends Node2D

@export var dir:Vector2

func _on_area_2d_body_entered(balloon):
	print(balloon)
	balloon.scalable_dir[dir] = true

func _on_area_2d_body_exited(balloon):
	balloon.scalable_dir[dir] = false
