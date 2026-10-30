class_name Ship extends RigidBody2D

@export_range(5,1) var hitPoints = 3

@export_range(200,800,5) var speed : float = 600

@export_category("Shooting")
@export var bullet : PackedScene
@export var pivot : Node2D

@export var initPos = Vector2.ZERO

var iFrames = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initPos = global_position
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if iFrames > 0:
		contact_monitor = false
		iFrames -= 1
		linear_velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("Shoot"):
		_shoot()

	var direction : Vector2 = Input.get_vector("Left","Right","Up","Down").normalized()
	linear_velocity = direction * speed
	pass

func _take_dmg() -> void:
	hitPoints-=1
	
	if hitPoints == 0:
		print_debug("Ship Destroyed")
		queue_free()
		pass
	
	global_position = initPos
	linear_velocity = Vector2.ZERO
	pass
	
func _shoot() -> void:
	var bulletObj = (bullet.instantiate() as Bullet)
	get_parent().add_child(bulletObj)
	bulletObj.global_position = pivot.global_position
	bulletObj.linear_velocity = Vector2.UP * 1000
pass
