extends Node2D
class_name Pushable

var child_colliders = []
var things_to_move = {}
	
func _ready():
	child_colliders = get_children()
			
func check_move_collision(dir:Vector2) -> bool:
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
	
func move(dir:Vector2, can_move:bool):
	for thing in things_to_move:
		thing.move(dir, can_move)
	things_to_move = {}
	if can_move:
		position += dir * 32
	else:
		pass
		#add 'not moving' animation
