extends Node2D

var turned_on:bool = false

func _on_area_2d_body_entered(_body):
	EventBus.no_tile.emit(true)
	turned_on = true

func _on_area_2d_body_exited(_body):
	EventBus.no_tile.emit(false)
	turned_on = false

func _process(delta):
	if Global.game_state != Global.STATES.MOVING:
		$On.visible = turned_on
		$Off.visible = !turned_on
