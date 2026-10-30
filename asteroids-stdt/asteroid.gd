class_name Asteroid extends RigidBody2D

enum Size
{
	Big, Medium, Small
}

@export var size : Size = Size.Big
@export var child : PackedScene

func _validate_scale() -> void:
	var set_scale = 0
	
	if size == Size.Big: set_scale = 1
	elif size == Size.Medium: set_scale = 0.5
	else: set_scale = 0.3
	
	#for child in get_children():
		#(child as Node2D).global_scale *= get_scale
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if size == Size.Big:
		global_scale = Vector2.ONE
	elif size == Size.Medium:
		global_scale = Vector2.ONE/2
	else:
		global_scale = Vector2.ONE/3
pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var colliders = get_colliding_bodies()
	for obj in colliders:
		if !(obj is Ship): continue
		(obj as Ship)._take_dmg()
	pass

func _take_dmg() -> void:
	#GameManager.score += 10
	
	if size == Size.Small:
		queue_free()
		return
	
	var newAsteroid1 = duplicate() as Asteroid
	var newASteroid2 = duplicate() as Asteroid
	get_parent().add_child(newAsteroid1)
	get_parent().add_child(newASteroid2)
	
	var newSize = Size.Medium
	#if size == Size.Medium:
		
	
	pass
