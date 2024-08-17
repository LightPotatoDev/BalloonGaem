extends Node2D

var colliders = []
	
func _ready():
	colliders = get_children()
	
func get_input():
	const INPUTS = {"ui_left":Vector2.LEFT, 
					"ui_right":Vector2.RIGHT, 
					"ui_up":Vector2.UP, 
					"ui_down":Vector2.DOWN}
	for key in INPUTS.keys():
		if Input.is_action_just_pressed(key):
			check_collision(INPUTS[key])
			
func check_collision(dir:Vector2):
	var results = []
	for child in colliders:
		results.append(child.check_collision(dir))
	for res in results:
		if res[0] == "wall":
			print('a')
	print(results)

func _physics_process(_delta):
	get_input()
