extends Node2D


func _input(event):
	if Input.is_action_just_pressed("undo"):
		EventBus.undo.emit()
