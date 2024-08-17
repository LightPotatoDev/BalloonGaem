extends Node2D


func _on_area_2d_body_entered(body):
	EventBus.no_tile_on.emit()
	$Off.visible = false
	$On.visible = true

func _on_area_2d_body_exited(body):
	EventBus.no_tile_off.emit()
	$On.visible = false
	$Off.visible = true
