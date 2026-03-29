extends Control

@onready var database: UpstashDatabase = $Database
var all_highscores: Dictionary

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	all_highscores = await database.get_all_highscores()
	var keys = all_highscores.keys()
	keys.sort_custom(func(a, b): return all_highscores[a] < all_highscores[b])
	for key in keys.slice(0,20,1):
		%ItemList.add_item(key + " - " + str(all_highscores[key]).pad_decimals(2))
		
		
var score: float:
	set(value):
		score = value
		%Label2.text = "Your Score: " + str(score).pad_decimals(2)


func _on_button_pressed() -> void:
	MusicPlayer.sfx.stream = MusicPlayer.CLICK
	MusicPlayer.sfx.play()
	if all_highscores != null:
		if %TextEdit.text:
			%Button.disabled = true
			var highscore = all_highscores.get(%TextEdit.text)
			if highscore:
				if score < highscore:
					database.save_highscore(%TextEdit.text,score)
			else:
				database.save_highscore(%TextEdit.text,score)
		
			await get_tree().create_timer(2).timeout
			
			get_tree().get_first_node_in_group("main").highscore_done()


func _on_button_2_pressed() -> void:
	MusicPlayer.sfx.stream = MusicPlayer.CLICK
	MusicPlayer.sfx.play()
	get_tree().get_first_node_in_group("main").highscore_done()
