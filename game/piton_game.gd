extends Node2D

signal minigame_finished
signal point_down

var loop_acuracy: float = 0
var block := false

func enable():
	$label/AnimationPlayer.speed_scale = randf_range(0.9,1.1)
	show()
	loop_acuracy = 0
	$label/AnimationPlayer.play("loop")


func disable():
	hide()
	$label/AnimationPlayer.stop()


func _loop_stop():
	if not block:
		point_down.emit()
		loop_acuracy = wrapf($label/AnimationPlayer.current_animation_position,0,0.5)
		$label/AnimationPlayer.pause()


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and not event.is_echo():
			MusicPlayer.sfx.stream = MusicPlayer.CLICK
			MusicPlayer.sfx.play()
			_loop_stop() 
			if (0.2 < loop_acuracy and loop_acuracy < 0.3):
				minigame_finished.emit()
			else:
				block = true
				$label/AnimationPlayer.speed_scale -= 0.1
				await get_tree().create_timer(0.8).timeout
				$label/AnimationPlayer.play("loop")
				await get_tree().create_timer(0.2).timeout
				block = false
				
