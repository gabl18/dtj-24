extends Node

const GAME = preload("uid://05angmyaimsw")
const UI = preload("uid://cy8dbpby5bjm6")

var game: Node2D
@onready var ui: Control = $UI


func start_game() -> void:
	game = GAME.instantiate()
	add_child(game)
	ui.queue_free()
