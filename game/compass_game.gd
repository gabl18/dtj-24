extends Node2D

signal minigame_finished

var pressed := false
var active = false

func enable():
	show()
	active = true
	$Sprite2D.rotation = randf_range(PI * 2/3, PI*4/3)

func disable():
	hide()
	active = false

var rotation_speed_factor: float = 0.05
var last_mouse_angle: float = 0.0

func _input(event: InputEvent) -> void:
	if active:
		if event is InputEventMouseMotion and pressed:
			var current_mouse_angle = $Sprite2D.to_local(event.position).angle()
			var angle_delta = current_mouse_angle - last_mouse_angle
			angle_delta = fposmod(angle_delta + PI, PI * 2) - PI
			$Sprite2D.rotation += angle_delta * rotation_speed_factor
			
			last_mouse_angle = current_mouse_angle


func _process(_delta: float) -> void:
	if active:
		if wrapf($Sprite2D.rotation,0,TAU) + 1 < 1.1 and wrapf($Sprite2D.rotation,0,TAU) + 1 > 0.9:
			if not $Timer.time_left:
				$Timer.start()
				await $Timer.timeout
				if wrapf($Sprite2D.rotation,0,TAU) + 1 < 1.1 and wrapf($Sprite2D.rotation,0,TAU) + 1 > 0.9:
					minigame_finished.emit()


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active:
		if event is InputEventMouseButton:
			if event.is_pressed() and not event.is_echo():
				pressed = true
				last_mouse_angle = $Sprite2D.to_local(event.position).angle()
			elif event.is_released():
				pressed = false
