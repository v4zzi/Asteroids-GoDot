extends Node

# Usamos @onready para que los encuentre automáticamente de la escena
@onready var score_display: TextEdit = $ScoreDisplay
@onready var win_lose_panel = $"Win Lose Panel" # El nodo contenedor o texto de victoria

func _ready() -> void:
	if win_lose_panel:
		win_lose_panel.hide() # Ocultamos el panel al iniciar el juego
		
	# Conectarnos a las señales del GameManager
	var gm = get_tree().get_first_node_in_group("GameManager")
	if gm:
		if gm.has_signal("game_won"):
			gm.game_won.connect(_on_game_won)
		if gm.has_signal("game_over"):
			gm.game_over.connect(_on_game_over)
	else:
		print_debug("No se encontró el GameManager en el grupo GameManager")

func _process(delta: float) -> void:
	if score_display:
		score_display.text = "Score: " + str(GameManager.score)

func _on_game_won() -> void:
	if win_lose_panel:
		# Si tu "Win Lose Panel" es un Label, le cambiamos el texto directamente
		if win_lose_panel is Label:
			win_lose_panel.text = "¡VICTORIA!\nOleada Limpiada"
		win_lose_panel.show() # Mostramos el panel en pantalla
	
	get_tree().paused = true # Pausamos el juego

func _on_game_over() -> void:
	if win_lose_panel:
		if win_lose_panel is Label:
			win_lose_panel.text = "¡GAME OVER!\nTe quedaste sin vidas"
		win_lose_panel.show() # Mostramos el panel en pantalla
		
	get_tree().paused = true # Pausamos el juego
