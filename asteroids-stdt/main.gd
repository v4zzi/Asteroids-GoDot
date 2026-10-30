class_name GameManger extends Node2D

static var score : int = 0

# Awake
func _init() -> void:
	print_debug("Game Started")
	score = 0
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Fixed Update
func _physics_process(delta: float) -> void:
	pass
