extends Node2D

@onready var armR_palm: CharacterBody2D = $ArmR/Palm
@onready var armL_palm: CharacterBody2D = $ArmL/Palm

var mouse_hover_zoneL: bool
var mouse_hover_zoneR: bool

var hand_is_active: bool
var active_hand_is_L: bool

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	hand_is_active = get_viewport_rect().has_point(mouse_pos)
	if hand_is_active:
		if active_hand_is_L:
			if mouse_pos.x > get_viewport_rect().size.x/2 + 25:
				active_hand_is_L = false
		else:
			if mouse_pos.x < get_viewport_rect().size.x/2 - 25:
				active_hand_is_L = true
				
	if hand_is_active:
		if active_hand_is_L:
			armL_palm.global_position = (mouse_pos - armL_palm.global_position) * 0.4 + armL_palm.global_position
			armL_palm.move_and_slide()
		else:
			armR_palm.global_position = (mouse_pos - armR_palm.global_position) * 0.4 + armR_palm.global_position
			armR_palm.move_and_slide()
	
