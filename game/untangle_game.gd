extends Node2D


var rope_is_pressed: bool
var rope_start_offset: Vector2

var active: bool

@export var rope_max_shake: int = 2000
@export var rope_max_vel: float = 10

signal rope_hold_change(held:bool)
signal finish_minigame

func disable():
	hide()
	active = false
	$Line2D.points[-1] = Vector2(855.0,160.0)

func play_trans_in_anim():
	await get_tree().create_timer(0.4).timeout
	show()
	
func play_trans_out_anim():
	await get_tree().create_timer(0.4).timeout
	hide()
	

func enable():
	show()
	active = true


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if active:
		if rope_is_pressed:
			if get_global_mouse_position().x < get_viewport_rect().size.x/2:
				rope_is_pressed = false
				rope_hold_change.emit(false)
			else:
			
				$Line2D.points[-1] = get_global_mouse_position() - $Line2D.global_position
		else:
			$Line2D.points[-1] = Vector2(855.0,160.0) - $Line2D.global_position
		#if int(rope_height) > rope_max_height:
			#active = false
			#await play_trans_out_anim()
			#finish_minigame.emit()
			#rope_height = 0
			#mouse_rope_start_height = 0


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if active:
		if event is InputEventMouseButton:
			if event.is_pressed() and not event.is_echo():
				rope_is_pressed = true
				rope_hold_change.emit(true)
				rope_start_offset = get_global_mouse_position() - $Line2D.points[-1]

func _on_main_hand_inactive() -> void:
	rope_is_pressed = false
	rope_hold_change.emit(false)
