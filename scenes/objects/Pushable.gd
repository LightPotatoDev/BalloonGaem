extends Node2D
class_name Pushable

var child_colliders = {}
var things_to_move = {}

@export var is_player:bool = false
var tween:Tween

var pos_history:PackedVector2Array = []
var history_pointer:int = -1
	
func _ready():
	for child in get_children():
		child_colliders[child.position] = child
	EventBus.undo.connect(_on_undo)
	EventBus.move.connect(_on_move)
		
func get_input():
	const INPUTS = {"ui_left":Vector2.LEFT, 
					"ui_right":Vector2.RIGHT, 
					"ui_up":Vector2.UP, 
					"ui_down":Vector2.DOWN}
	for key in INPUTS.keys():
		if is_player and Input.is_action_just_pressed(key):
			if check_move_collision(INPUTS[key]):
				instant_finish_tween()
				EventBus.move.emit()
				move(INPUTS[key])
			else:
				cant_move(INPUTS[key])
			
	if Input.is_action_just_pressed("ui_copy"):
		print(pos_history)
		
func _physics_process(_delta):
	get_input()
			
func check_move_collision(dir:Vector2, exclude_list = []) -> bool:
	var cols = []
	for child in child_colliders.values():
		cols.append(child.check_collision(dir))
		
	var movable:bool = true
	for col in cols:
		if movable == false:
			things_to_move = {} #used as set
			break
		if col == null:
			continue
			
		var group = col.get_groups()[0]
		if group == "wall":
			movable = false
		exclude_list.append(self)
		if group == "balloon" and col.get_parent() not in exclude_list:
			movable = col.get_parent().check_move_collision(dir, exclude_list)
			if movable:
				things_to_move[col.get_parent()] = null

	return movable
	
func move(dir:Vector2):
	for thing in things_to_move:
		thing.move(dir)
	things_to_move = {}
	instant_finish_tween()
	tween = create_tween()
	tween.tween_property(self,"position",position+dir*32,0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func cant_move(dir:Vector2):
	pass
	#TODO - add 'not moving' animation
		
func _on_move():
	add_history(position)
	
func add_history(pos:Vector2):
	history_pointer += 1
	pos_history.append(pos)
	
func instant_finish_tween():
	if tween != null and tween.is_running():
		tween.pause()
		tween.custom_step(1)
	
func _on_undo():
	if history_pointer == -1:
		print('nothing to undo')
		return
		
	position = pos_history[history_pointer]
	pos_history.remove_at(pos_history.size()-1)
	history_pointer -= 1
		
	
