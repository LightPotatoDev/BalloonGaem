extends Node2D

var turned_on:bool = false

func _ready():
	EventBus.yes_tile_exist.emit()

func _on_area_2d_body_entered(_body):
	EventBus.yes_tile.emit(true)
	turned_on = true

func _on_area_2d_body_exited(_body):
	EventBus.yes_tile.emit(false)
	turned_on = false

func _process(delta):
	if Global.game_state != Global.STATES.MOVING:
		$On.visible = turned_on
		$Off.visible = !turned_on
