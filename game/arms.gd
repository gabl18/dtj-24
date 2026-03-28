extends Node2D

@onready var armR: CharacterBody2D = $ArmR/ArmTop
@onready var armL: CharacterBody2D = $ArmL/ArmTop

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
			if mouse_pos.x > get_viewport_rect().size.x/2 + 100:
				active_hand_is_L = false
		else:
			if mouse_pos.x < get_viewport_rect().size.x/2 - 100:
				active_hand_is_L = true
				
	if hand_is_active:
		if active_hand_is_L:
			armL.global_position = mouse_pos
		else:
			armR.global_position = mouse_pos
