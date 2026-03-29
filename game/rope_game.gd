extends Node2D

@onready var parallax_2d: Parallax2D = $Parallax2D

var rope_height: float = 0
var rope_is_pressed: bool
var mouse_rope_start_height: float

var active: bool

@export var rope_max_height: int = 2000

signal finish_minigame

func disable():
	hide()
	active = false

func play_trans_in_anim():
	show()
	$AnimationPlayer.play("trans_in")
	
func play_trans_out_anim():
	$AnimationPlayer.play("trans_out")
	await $AnimationPlayer.animation_finished

func enable():
	show()
	active = true


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if active:
		if rope_is_pressed:
			rope_height = clamp(get_local_mouse_position().y + mouse_rope_start_height,rope_height,INF)
		
		parallax_2d.scroll_offset.y = rope_height
		
		if int(rope_height) > rope_max_height:
			active = false
			await play_trans_out_anim()
			finish_minigame.emit()
			rope_height = 0
			mouse_rope_start_height = 0


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active:
		if event is InputEventMouseButton:
			if event.is_pressed() and not event.is_echo():
				rope_is_pressed = true
				mouse_rope_start_height = rope_height - event.position.y
			elif event.is_released():
				rope_is_pressed = false


func _on_main_hand_inactive() -> void:
	rope_is_pressed = false
