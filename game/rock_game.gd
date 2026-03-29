extends Node2D
@onready var rock_1: StaticBody2D = $Rocks/Rock
@onready var rock_2: StaticBody2D = $Rocks/Rock2
@onready var rock_array: Array = [rock_2,rock_1]

@onready var parallax_2d: Parallax2D = $Parallax2D
@onready var rocks: Node2D = $Rocks

signal height_updated(height:float)

var height: float = 0
var mouse_on_rock: bool
var rock_is_pressed: bool
var mouse_rock_start_height: float

var spawn_rock_L: bool = false


var active: bool = true

@export var rock_distance: int = 500
var last_rock_distance: int = 0

func disable():
	active = false
	

func enable():
	rock_is_pressed = false
	mouse_on_rock = false
	mouse_rock_start_height = 0
	active = true


func _ready() -> void:
	for rock in rock_array:
		rock.connect("mouse_entered",_rock_mouse_entered)
		rock.connect("mouse_exited",_rock_mouse_exited)
		rock.connect("input_event",_rock_input_event)
	_reposition_rock(400)
	_reposition_rock(-100)


func _process(_delta: float) -> void:
	if active:
		if rock_is_pressed:
			height = clamp(get_local_mouse_position().y + mouse_rock_start_height,height,INF)
			height_updated.emit(height)
		if int(height) > last_rock_distance + rock_distance:
			_reposition_rock()
			last_rock_distance = last_rock_distance + rock_distance
		
		
		parallax_2d.scroll_offset.y = height
		rocks.position.y = height


func _reposition_rock(height_override: float = 0):
	var rock = rock_array.pop_front()
	rock_array.append(rock)

	if spawn_rock_L:
		spawn_rock_L = false
		@warning_ignore("narrowing_conversion")
		rock.position.x = randi_range(get_viewport_rect().size.x * 0.1, get_viewport_rect().size.x * 0.40)
	else:
		spawn_rock_L = true
		@warning_ignore("narrowing_conversion")
		rock.position.x = randi_range(get_viewport_rect().size.x * 0.60, get_viewport_rect().size.x * 0.9)

	rock.global_position.y = -50 + height_override
	rock.reset_size()


func _rock_mouse_entered():
	mouse_on_rock = true


func _rock_mouse_exited():
	mouse_on_rock = false


func _rock_input_event(__,event:InputEvent,___):
	if active:
		if event is InputEventMouseButton:
			if event.is_pressed() and not event.is_echo():
				rock_is_pressed = true
				
				mouse_rock_start_height = height - event.position.y
			elif event.is_released():
				rock_is_pressed = false


func _on_main_hand_inactive() -> void:
	rock_is_pressed = false
