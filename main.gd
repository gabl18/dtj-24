extends Node

const GAME = preload("uid://05angmyaimsw")
const UI = preload("uid://cy8dbpby5bjm6")
const HIGHSCORE_UI = preload("uid://u2fh21jyomaj")

var game: Node2D
var hUI: Control
@onready var ui: Control = $UI


func start_game() -> void:
	game = GAME.instantiate()
	add_child(game)
	ui.queue_free()
	
func game_done(time:float):
	game.queue_free()
	hUI = HIGHSCORE_UI.instantiate()
	add_child(hUI)
	hUI.score = time


func highscore_done():
	hUI.queue_free()
	ui = UI.instantiate()
	add_child(ui)
	ui.texture_button.pressed.connect(start_game)
