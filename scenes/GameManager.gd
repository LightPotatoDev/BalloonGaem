extends Node2D


func _input(event):
	if Input.is_action_just_pressed("undo"):
		EventBus.undo.emit()
	if Input.is_action_just_pressed("ui_accept"):
		EventBus.move.emit()
