@abstract class_name A_Asteroid extends RigidBody2D

@export_range(0,500) var reward : int = 10
@export var speed : float = 150.0

var direction : Vector2 = Vector2.RIGHT
var On_Dmg_Tkn_Signal : Signal

func _ready() -> void:
	if not is_in_group("Asteroids"):
		add_to_group("Asteroids")
	
	# Desactivar la gravedad del motor de físicas para que floten en el espacio
	gravity_scale = 0.0
	
	body_entered.connect(damage_ship)
	
	# Si no se le ha asignado una dirección, le damos una aleatoria al nacer
	if direction == Vector2.RIGHT:
		direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	pass

func _physics_process(delta: float) -> void:
	# Movimiento constante del asteroide en su dirección
	global_position += direction * speed * delta
	
	# Pantalla toroidal (reaparecer al otro lado si sale de los límites de la pantalla)
	if global_position.x > 1152: global_position.x = 0
	elif global_position.x < 0: global_position.x = 1152
	if global_position.y > 648: global_position.y = 0
	elif global_position.y < 0: global_position.y = 648
	pass

func damage_ship(other : RigidBody2D) -> void:
	if!(other is Ship): return
	(other as Ship)._take_dmg()
	pass

func take_dmg() -> void:
	GameManager.score += 10
	on_dmg_tkn()
	On_Dmg_Tkn_Signal.emit()
	pass

@abstract func on_dmg_tkn() -> void
