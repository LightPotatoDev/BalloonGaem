extends Pushable
class_name Balloon

const BALLOON_COL = preload("res://scenes/objects/BalloonCollision.tscn")

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_action_just_pressed("ui_accept"):
		scale_balloon(Vector2.DOWN)
				
func scale_balloon(dir:Vector2):
	var pos_to_add = []
	for child in child_colliders.values():
		if child.check_collision(dir) == null and (child.position+dir*32) not in child_colliders:
			pos_to_add.append(child.position + dir * 32)
			
	print(pos_to_add)
	for pos in pos_to_add:
		add_balloon_child(pos)

func add_balloon_child(pos:Vector2):
	var bal_col = BALLOON_COL.instantiate()
	bal_col.position = pos
	child_colliders[pos] = bal_col
	add_child(bal_col)
