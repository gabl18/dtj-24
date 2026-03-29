extends Node2D

var pressed := false
var active = false
signal flag_height_value_changed(flag_height_value)
signal winwin
@export var kurve: Curve 

var rotation_value: float
var flag_height_value: float

var offset_rotation: float = 0

func enable():
	show()
	active = true
	$Sprite2D.rotation = offset_rotation + deg_to_rad(0)


var rotation_speed_factor: float = 1
var last_mouse_angle: float = 0.0

func _input(event: InputEvent) -> void:
	if active:
		if event is InputEventMouseMotion and pressed:
			var current_mouse_angle = to_local(event.position).angle()
			var angle_delta = current_mouse_angle - last_mouse_angle
			angle_delta = fposmod(angle_delta + PI, PI * 2) - PI
			offset_rotation += clamp(angle_delta * rotation_speed_factor,0,INF)
			
			last_mouse_angle = current_mouse_angle
			
			$Sprite2D.rotation = offset_rotation
			
			rotation_value = offset_rotation / 100
			
			flag_height_value = kurve.sample_baked(rotation_value)
			flag_height_value_changed.emit(flag_height_value)
			if flag_height_value >= 1:
				active = false
				winwin.emit()
				


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active:
		if event is InputEventMouseButton:
			if event.is_pressed() and not event.is_echo():
				pressed = true
				last_mouse_angle = to_local(event.position).angle()
			elif event.is_released():
				pressed = false
