extends Node2D
class_name Pushable

var child_colliders = {}
var things_to_move = {}

@export var is_player:bool = false

func get_input():
	const INPUTS = {"ui_left":Vector2.LEFT, 
					"ui_right":Vector2.RIGHT, 
					"ui_up":Vector2.UP, 
					"ui_down":Vector2.DOWN}
	for key in INPUTS.keys():
		if Input.is_action_just_pressed(key):
			move(INPUTS[key], check_move_collision(INPUTS[key]))
	
func _ready():
	for child in get_children():
		child_colliders[child.position] = child
			
func check_move_collision(dir:Vector2) -> bool:
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
		if group == "balloon" and col.get_parent() != self:
			movable = col.get_parent().check_move_collision(dir)
			if movable:
				things_to_move[col.get_parent()] = null

	return movable
	
func move(dir:Vector2, can_move:bool):
	for thing in things_to_move:
		thing.move(dir, can_move)
	things_to_move = {}
	if can_move:
		position += dir * 32
	else:
		pass
		#add 'not moving' animation
		
func _physics_process(_delta):
	if is_player:
		get_input()
