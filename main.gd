extends Node2D

enum games {
	rockgame,
	rope
}
@onready var climb_timer: Timer = $ClimbTimer

@onready var rock_game: Node2D = $RockGame
@onready var rope_game: Node2D = $RopeGame

var active_game := games.rockgame

var height: float


func _ready() -> void:
	climb_timer.start()


func change_game():
	if active_game == games.rockgame:
		rock_game.enable()
		climb_both_hands = true
	else:
		rock_game.disable()
		climb_both_hands = false
	
	if active_game == games.rope:
		rope_game.enable()
		climb_rope = true
	else:
		rope_game.disable()
		climb_rope = false


func _play_minigame() -> void:
	active_game = games.rope
	change_game()
	print(23)


func _finished_minigame():
	print(121212)
	active_game = games.rockgame
	change_game()
	climb_timer.start()


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
var hand_is_closed: bool

var climb_both_hands:bool = true
var climb_rope:bool = false

signal hand_inactive


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if climb_both_hands:
			if event.is_pressed():
				hand_is_closed = true
				if not active_hand_is_L:
					armR_animated_sprite_2d.animation = "close"
				else:
					armL_animated_sprite_2d.animation = "close"
			else:
				hand_is_closed = false
				armR_animated_sprite_2d.animation = "open"
				armL_animated_sprite_2d.animation = "open"
		
		elif climb_rope:
			if event.is_released() and not event.is_echo():
				active_hand_is_L = not active_hand_is_L
				
			if event.is_pressed():
				hand_is_closed = true
				if not active_hand_is_L:
					armR_animated_sprite_2d.animation = "rope_close"
				else:
					armL_animated_sprite_2d.animation = "rope_close"
			else:
				hand_is_closed = false
				armR_animated_sprite_2d.animation = "open"
				armL_animated_sprite_2d.animation = "open"


func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	hand_is_active = get_viewport_rect().has_point(mouse_pos)
	if not hand_is_active:
		hand_inactive.emit()
	if climb_both_hands:
		
		if hand_is_active:
			if active_hand_is_L:
				if mouse_pos.x > get_viewport_rect().size.x/2 + 25:
					active_hand_is_L = false
			else:
				if mouse_pos.x < get_viewport_rect().size.x/2 - 25:
					active_hand_is_L = true
					
		if hand_is_active:
			if active_hand_is_L:
				if not hand_is_closed:
					armL_palm.global_position.x = (mouse_pos.x - armL_palm.global_position.x) * 0.4 + armL_palm.global_position.x
				armL_palm.global_position.y = (mouse_pos.y - armL_palm.global_position.y) * 0.4 + armL_palm.global_position.y
				armL_palm.move_and_slide()
				armL.z_index = 1
				armR.z_index = 0

			else:
				if not hand_is_closed:
					armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.4 + armR_palm.global_position.x
				armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.4 + armR_palm.global_position.y
				armR_palm.move_and_slide()
				
				armR.z_index = 1
				armL.z_index = 0
	
	elif climb_rope:
		if hand_is_active:
			if active_hand_is_L:
				if not hand_is_closed:
					armL_palm.global_position.x = clamp((mouse_pos.x - armL_palm.global_position.x) * 0.4 + armL_palm.global_position.x, 0, get_viewport_rect().size.x/2)
				armL_palm.global_position.y = (mouse_pos.y - armL_palm.global_position.y) * 0.4 + armL_palm.global_position.y
				armL_palm.move_and_slide()
				armL.z_index = 1
				armR.z_index = 0

			else:
				if not hand_is_closed:
					armR_palm.global_position.x = clamp((mouse_pos.x - armR_palm.global_position.x) * 0.4 + armR_palm.global_position.x, get_viewport_rect().size.x/2, get_viewport_rect().size.x)
				armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.4 + armR_palm.global_position.y
				armR_palm.move_and_slide()
				
				armR.z_index = 1
				armL.z_index = 0


func _on_climb_timer_timeout() -> void:
	_play_minigame()
