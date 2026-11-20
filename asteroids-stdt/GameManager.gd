class_name GameManager extends Node2D

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_won
signal game_over

static var me : Node2D
static var score : int = 0
static var continuos_actions: Signal

@export var max_lives: int = 3
var current_lives: int = 3

@export var asteroid_scene: PackedScene # Arrastra tu escena de NormalAsteroid aquí en el Inspector
@export var initial_asteroids_count: int = 4 # Número de asteroides grandes al iniciar

func _init() -> void:
	print_debug("Game Started")
	me = self
	score = 0
	pass

func _ready() -> void:
	current_lives = max_lives
	score_changed.emit(score)
	lives_changed.emit(current_lives)
	
	"start_wave()"

func start_wave() -> void:
	if asteroid_scene == null:
		print_debug("¡Falta asignar la escena del asteroide en el GameManager!")
		return

	for i in range(initial_asteroids_count):
		var asteroid = asteroid_scene.instantiate() as NormalAsteroid
		asteroid.size = NormalAsteroid.Size.Big
		
		# Posición aleatoria evitando el centro (donde nace la nave)
		var random_pos = Vector2(randf_range(100, 1052), randf_range(100, 548))
		while random_pos.distance_to(Vector2(576, 324)) < 200:
			random_pos = Vector2(randf_range(100, 1052), randf_range(100, 548))
			
		asteroid.global_position = random_pos
		get_tree().current_scene.add_child(asteroid)


func player_hit() -> void:
	current_lives -= 1
	lives_changed.emit(current_lives)
	
	if current_lives <= 0:
		game_over.emit()
		print_debug("¡Derrota! Te quedaste sin vidas.")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Contar cuántos asteroides quedan vivos en el grupo "Asteroids"
	var remaining_asteroids = get_tree().get_nodes_in_group("Asteroids").size()
	
	# Condición de Victoria: Si no quedan asteroides y ya pasó un momento desde que inició el juego
	if remaining_asteroids == 0 and Engine.get_process_frames() > 60:
		game_won.emit()
		print_debug("¡Victoria! Oleada limpiada.")
		set_process(false) # Detenemos el proceso para que no se dispare múltiples veces
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	continuos_actions.emit()
	pass

static func delay_action(action: Callable, delay) -> void:
	await  me.get_tree().create_timer(delay).timeout
	action.call()
	pass
