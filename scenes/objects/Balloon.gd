extends Pushable
class_name Balloon

const BALLOON_COL = preload("res://scenes/objects/BalloonCollision.tscn")
var scalable_dir = {Vector2.UP:false, Vector2.RIGHT:false, Vector2.DOWN:false, Vector2.LEFT:false}
var child_col_hist = []

func get_input():
	super.get_input()
	if Global.game_state != Global.STATES.DEFAULT:
		return
	if Input.is_action_just_pressed("ui_accept"):
		var pos_to_add:Dictionary = {} #used as set
		for dir in scalable_dir:
			if scalable_dir[dir] == true:
				for p in scale_balloon(dir):
					pos_to_add[p] = null
				
		for pos in pos_to_add.keys():
			add_balloon_child(pos)
			
		for col in child_colliders.values():
			col.check_nearby_balloon()
				
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
	
func _on_move():
	super._on_move()
	child_col_hist.append(child_colliders.duplicate(true))

func _on_undo():
	super._on_undo()
	if child_col_hist.size() == 0:
		return
	
	var prev_child:Dictionary = child_col_hist[-1]
	var to_delete = []
	
	for pos in child_colliders:
		if pos not in prev_child:
			to_delete.append(pos)
	for pos in to_delete:
		remove_child(child_colliders[pos])
		child_colliders[pos].queue_free()
	child_colliders = prev_child.duplicate(true)
	child_col_hist.remove_at(child_col_hist.size()-1)
