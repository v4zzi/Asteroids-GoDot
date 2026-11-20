class_name Bullet extends ABullet

@warning_ignore("unused_parameter")
func on_physics_process(delta : float) -> void:
	pass

@warning_ignore("unused_parameter")
func on_asteroid_collision(asteroid : A_Asteroid):
	queue_free()
	pass
