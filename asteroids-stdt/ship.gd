class_name Ship extends RigidBody2D

@export_range(1, 5) var hitPoints = 3
@export_range(200,800, 5) var speed : float = 600

@export_category("Shooting")
@export var bullet: PackedScene 

# Como tu Pivot está dentro de Sprite2D, podemos referenciarlo automáticamente con @onready
@onready var sprite_visual: Sprite2D = $Sprite2D
@onready var pivot: Node2D = $Sprite2D/Pivot

var initPos = Vector2.ZERO
var iFrames = 0

# Start
func _ready() -> void:
	initPos = global_position
	
	contact_monitor = true
	max_contacts_reported = 4
	
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

# Update
func _process(delta: float) -> void:
	# Pantalla toroidal (cruzar los bordes)
	if global_position.x >= 1152 - 28: global_position.x = 0 + 30
	if global_position.x <= 0 + 28: global_position.x = 1152 - 30
	if global_position.y >= 648 - 28: global_position.y = 0 + 30
	if global_position.y <= 0 + 28: global_position.y = 648 - 30
	
	# === APUNTAR AL MOUSE (Rotando únicamente el Sprite2D) ===
	if sprite_visual:
		sprite_visual.look_at(get_global_mouse_position())
		sprite_visual.rotation += PI / 2 # Ajuste de 90 grados para que coincida con el sprite hacia arriba

# Fixed Update
func _physics_process(delta: float) -> void:
	if iFrames > 0:
		iFrames -= 1
		
	if Input.is_action_just_pressed("Shoot"):
		_shoot()
		
	var direction: Vector2 = Input.get_vector("Left","Right","Up","Down").normalized()
	linear_velocity = direction * speed

func _on_body_entered(body: Node) -> void:
	if body is A_Asteroid:
		_take_dmg()
		body.take_dmg() 

func _take_dmg() -> void:
	if iFrames > 0: return
	
	hitPoints -= 1
	teleport(initPos)
	linear_velocity = Vector2.ZERO
	iFrames = 60 
	
	var gm = get_tree().get_first_node_in_group("GameManager")
	if gm:
		gm.player_hit() 
	
	if hitPoints <= 0:
		queue_free()
		print_debug("Ship Destroyed")

func _shoot() -> void:
	if bullet == null or pivot == null: return
	
	var bulletobjt = bullet.instantiate() as RigidBody2D
	get_parent().add_child(bulletobjt)
	
	# La bala nace exactamente en la posición del Pivot (que ya rota con la nave)
	bulletobjt.global_position = pivot.global_position
	
	# Sale disparada hacia adelante según la rotación visual del Sprite2D
	var shoot_dir = Vector2.UP.rotated(sprite_visual.global_rotation)
	bulletobjt.linear_velocity = shoot_dir * 1000
	bulletobjt.global_rotation = sprite_visual.global_rotation

func teleport(pos : Vector2) -> void:
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(pos)
	)
