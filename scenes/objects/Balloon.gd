extends Pushable
class_name Balloon

@export var is_player:bool = false
const BALLOON_COL = preload("res://scenes/objects/BalloonCollision.tscn")

func get_input():
	const INPUTS = {"ui_left":Vector2.LEFT, 
					"ui_right":Vector2.RIGHT, 
					"ui_up":Vector2.UP, 
					"ui_down":Vector2.DOWN}
	for key in INPUTS.keys():
		if Input.is_action_just_pressed(key):
			move(INPUTS[key], check_move_collision(INPUTS[key]))
				
func check_scale_collision(dir:Vector2):
	var cols = []
	for child in child_colliders:
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
	
func _physics_process(_delta):
	if is_player:
		get_input()
