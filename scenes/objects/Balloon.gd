extends Pushable
class_name Balloon

const BALLOON_COL = preload("res://scenes/objects/BalloonCollision.tscn")
var scalable_dir = {Vector2.UP:false, Vector2.RIGHT:false, Vector2.DOWN:false, Vector2.LEFT:false}

func get_input():
	super.get_input()
	if Input.is_action_just_pressed("ui_accept"):
		var pos_to_add:PackedVector2Array = []
		for dir in scalable_dir:
			if scalable_dir[dir] == true:
				pos_to_add.append_array(scale_balloon(dir))
				
		for pos in pos_to_add:
			add_balloon_child(pos)
				
func scale_balloon(dir:Vector2) -> PackedVector2Array:
	var pos_to_add:PackedVector2Array = []
	for child in child_colliders.values():
		if child.check_collision(dir) == null and (child.position+dir*32) not in child_colliders:
			pos_to_add.append(child.position + dir * 32)
			
	return pos_to_add

func add_balloon_child(pos:Vector2):
	var bal_col = BALLOON_COL.instantiate()
	bal_col.position = pos
	child_colliders[pos] = bal_col
	add_child(bal_col)
