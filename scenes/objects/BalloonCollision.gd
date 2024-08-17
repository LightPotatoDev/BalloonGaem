extends CharacterBody2D

@onready var ray:RayCast2D = $RayCast2D

func check_collision(dir:Vector2):
	ray.target_position = dir * 32
	ray.force_raycast_update()
	if ray.is_colliding():
		return ray.get_collider()
	return null

func check_nearby_balloon():
	const DIR = [Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(-1,1),
				Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]
	const LEN = [32,45]
	var res = []
	
	for i in range(8):
		ray.target_position = DIR[i] * LEN[i%2]
		ray.force_raycast_update()
		res.append(ray.is_colliding() and ray.get_collider().get_parent() == self.get_parent())

	print(res)
	return res
