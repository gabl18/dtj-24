extends Node2D

var active: bool

@export var max_taps: float = 15

var taps := 0

signal tap
signal finish_minigame


func disable():
	hide()
	active = false


func play_trans_in_anim():
	await get_tree().create_timer(1).timeout
	show()


func play_trans_out_anim():
	pass


func enable():
	active = true


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active:
		if event is InputEventMouseButton:
			if event.is_pressed() and not event.is_echo():
				taps += 1
				MusicPlayer.sfx.stream = MusicPlayer.get_random_chalk_noise()
				MusicPlayer.sfx.play()
				$CPUParticles2D.emitting = true
				tap.emit()
				if taps >= max_taps:
					finish_minigame.emit()
					taps = 0
