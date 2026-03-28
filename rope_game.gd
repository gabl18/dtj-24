extends Node2D

@onready var parallax_2d: Parallax2D = $Parallax2D

var rope_height: float = 0
var rope_is_pressed: bool
var mouse_rope_start_height: float

@export var rope_max_height: int = 2000

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if rope_is_pressed:
		rope_height = clamp(get_local_mouse_position().y + mouse_rope_start_height,rope_height,INF)
	
	parallax_2d.scroll_offset.y = rope_height


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and not event.is_echo():
			rope_is_pressed = true
			mouse_rope_start_height = rope_height - event.position.y
		elif event.is_released():
			rope_is_pressed = false
