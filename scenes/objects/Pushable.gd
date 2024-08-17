extends Node2D
class_name Pushable

var child_colliders = {}
var things_to_move = {}

@export var is_player:bool = false
var is_moving:bool = false

func get_input():
	const INPUTS = {"ui_left":Vector2.LEFT, 
					"ui_right":Vector2.RIGHT, 
					"ui_up":Vector2.UP, 
					"ui_down":Vector2.DOWN}
	for key in INPUTS.keys():
		if is_player and Input.is_action_just_pressed(key):
			move(INPUTS[key], check_move_collision(INPUTS[key]))
	
func _ready():
	for child in get_children():
		child_colliders[child.position] = child
			
func check_move_collision(dir:Vector2, exclude_list = []) -> bool:
	var cols = []
	for child in child_colliders.values():
		cols.append(child.check_collision(dir))
		
	var movable:bool = true
	for col in cols:
		if movable == false:
			things_to_move = {}
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
	
func move(dir:Vector2, can_move:bool):
	for thing in things_to_move:
		thing.move(dir, can_move)
	things_to_move = {}
	if can_move and not is_moving:
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self,"position",position+dir*32,0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		is_moving = false
		#position += dir * 32
	else:
		pass
		#add 'not moving' animation
		
func _physics_process(_delta):
	get_input()
