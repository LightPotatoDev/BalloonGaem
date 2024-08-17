extends CharacterBody2D

@onready var ray:RayCast2D = $RayCast2D

func check_collision(dir:Vector2) -> String:
	ray.target_position = dir * 32
	ray.force_raycast_update()
	if ray.is_colliding():
		return ray.get_collider().get_groups()[0]
	return "null"
