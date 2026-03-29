extends Node2D

@onready var dude: Sprite2D = $Bar/Dude

var value : float = 0: 
	set(val):
		value = val
		set_value(val)

var lower_bound := 57.5
var upper_bound := -54.25

func set_value(val:float):
	var height = lerp(lower_bound,upper_bound,val)
	var tween = get_tree().create_tween()
	tween.tween_property(dude,"position:y",height,0.5)
	$AnimationPlayer.play("wiggle")
	await tween.finished
	$AnimationPlayer.pause()


func _on_main_win() -> void:
	$ConfettiCannon.emitting = true
	MusicPlayer.sfx.stream = MusicPlayer.PARTY_HORN
	MusicPlayer.sfx.play()


func _on_wheel_winwin() -> void:
	$ConfettiCannon.one_shot = false
	$ConfettiCannon.emitting = true
	$ConfettiCannon2.emitting = true
	MusicPlayer.sfx.stream = MusicPlayer.PARTY_HORN
	MusicPlayer.sfx.play()
