extends Node2D

@onready var armR: Node2D = $ArmR
@onready var armL: Node2D = $ArmL

@onready var armR_palm: CharacterBody2D = $ArmR/Palm
@onready var armL_palm: CharacterBody2D = $ArmL/Palm

@onready var armR_animated_sprite_2d: AnimatedSprite2D = $ArmR/Palm/AnimatedSprite2D
@onready var armL_animated_sprite_2d: AnimatedSprite2D = $ArmL/Palm/AnimatedSprite2D

var mouse_hover_zoneL: bool
var mouse_hover_zoneR: bool

var hand_is_active: bool
var active_hand_is_L: bool

func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if not active_hand_is_L:
				armR_animated_sprite_2d.animation = "close"
			else:
				armL_animated_sprite_2d.animation = "close"
		else:
			armR_animated_sprite_2d.animation = "open"
			armL_animated_sprite_2d.animation = "open"


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
			armL.z_index = 1
			armR.z_index = 0

		else:
			armR_palm.global_position = (mouse_pos - armR_palm.global_position) * 0.4 + armR_palm.global_position
			armR_palm.move_and_slide()
			
			armR.z_index = 1
			armL.z_index = 0
			
			
	
	
