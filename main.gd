extends Node2D

@onready var border_anim_player: AnimationPlayer = $Border/AnimationPlayer


@onready var shoutouts: Sprite2D = $Shoutouts

enum games {
	rockgame,
	rope,
	untangle,
	chalk,
	piton
}

@onready var climb_timer: Timer = $ClimbTimer

@onready var rock_game: Node2D = $RockGame
@onready var rope_game: Node2D = $RopeGame
@onready var untangle_game: Node2D = $UntangleGame
@onready var chalk_game: Node2D = $ChalkGame
@onready var piton_game: Node2D = $PitonGame

var active_game := games.rockgame

var height: float


func _ready() -> void:
	climb_timer.start()


func change_game():
	hand_is_closed = false
	_disable_game()
	if not active_game == games.rockgame:
		_play_game_trans_in()
		border_anim_player.play("trans_in")
		await get_tree().create_timer(1).timeout
	_enable_game()


func _disable_game():
	if active_game != games.rockgame:
		rock_game.disable()
		rock_game.modulate = Color(0.385, 0.385, 0.385, 1.0)
		climb_both_hands = false
	
	if active_game != games.rope:
		rope_game.disable()
		climb_rope = false
	
	if active_game != games.untangle:
		untangle_game.disable()
		rope_untangle = false
	
	if active_game != games.chalk:
		chalk_game.disable()
		chalk_bag = false

	if active_game != games.piton:
		piton_game.disable()
		piton_place = false


func _enable_game():
	if active_game == games.rockgame:
		rock_game.enable()
		rock_game.modulate = Color(1.0, 1.0, 1.0, 1.0)
		climb_both_hands = true

	if active_game == games.rope:
		rope_game.enable()

	if active_game == games.untangle:
		untangle_game.enable()
	
	if active_game == games.chalk:
		chalk_game.enable()
		
	
	if active_game == games.piton:
		piton_game.enable()
		
		

func _play_game_trans_in():
	if active_game == games.rope:
		rope_game.play_trans_in_anim()
		climb_rope = true
		_show_shoutout(5)
		
	if active_game == games.untangle:
		untangle_game.play_trans_in_anim()
		rope_untangle = true
		armR_animated_sprite_2d.animation = "open"
		_show_shoutout(7)
		
		var tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(-50,250),0.4)
		await tween.finished
		tween.kill()
		armL_animated_sprite_2d.animation = "rope"
		tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(400,160),0.6)
		await tween.finished
		tween.kill()
		
	if active_game == games.chalk:
		chalk_bag = true
		chalk_game.play_trans_in_anim()
		armR_animated_sprite_2d.animation = "open"
		_show_shoutout(3)
		
		var tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(-50,250),0.4)
		await tween.finished
		tween.kill()
		armL_animated_sprite_2d.animation = "chalk"
		tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(600,260),0.6)
		await tween.finished
		tween.kill()
	
	if active_game == games.piton:
		piton_place = true
		armR_animated_sprite_2d.animation = "point"
		var tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(-50,250),0.4)
		await tween.finished
		tween.kill()


func _play_minigame() -> void:
	active_game = randi_range(1,4) as games
	change_game()


func _finished_minigame():
	border_anim_player.play("trans_out")
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
var rope_untangle:bool = false
var chalk_bag:bool = false
var piton_place:bool = false

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
	
	elif rope_untangle:
		if hand_is_active:
			armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.4 + armR_palm.global_position.x
			armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.4 + armR_palm.global_position.y
			armR_palm.move_and_slide()
			armR.z_index = 1
			armL.z_index = 0
			
	elif chalk_bag:
		if hand_is_active:
			armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.4 + armR_palm.global_position.x
			armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.4 + armR_palm.global_position.y
			armR_palm.move_and_slide()
			armR.z_index = 1
			armL.z_index = 0
	
	elif piton_place:
		if hand_is_active:
			armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.4 + armR_palm.global_position.x
			armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.4 + armR_palm.global_position.y
			armR_palm.move_and_slide()
			armR.z_index = 1
			armL.z_index = 0

func _on_climb_timer_timeout() -> void:
	_play_minigame()


func _on_untangle_game_rope_hold_change(held: bool) -> void:
	if rope_untangle:
		if held:
			hand_is_closed = true
			armR_animated_sprite_2d.animation = "rope_close"
		else:
			hand_is_closed = false
			armR_animated_sprite_2d.animation = "open"


func _on_untangle_disable():
	var tween = get_tree().create_tween()
	tween.tween_property(armL_palm,"global_position",Vector2(400,160),0.2)
	await tween.finished
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(armL_palm,"global_position",Vector2(-50,250),0.4)
	await tween.finished
	tween.kill()
	armL_animated_sprite_2d.animation = "open"


func _show_shoutout(index:int):
	shoutouts.frame = index
	shoutouts.show()
	await get_tree().create_timer(1).timeout
	shoutouts.hide()


func _on_untangle_game_finish_minigame() -> void:
	_on_untangle_disable()


func _on_chalk_game_finish_minigame() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(armL_palm,"global_position",Vector2(600,250),0.2)
	await tween.finished
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(armL_palm,"global_position",Vector2(-50,250),0.4)
	await tween.finished
	tween.kill()
	armL_animated_sprite_2d.animation = "open"


func _on_chalk_game_tap() -> void:
	armR_animated_sprite_2d.animation = "close"
	await get_tree().create_timer(0.1).timeout
	armR_animated_sprite_2d.animation = "open"


func _on_piton_game_minigame_finished() -> void:
	var sprite = piton_game.get_child(0).duplicate()
	var pos = sprite.global_position
	rock_game.rocks.add_child(sprite)
	sprite.global_position = pos
	await get_tree().create_timer(10).timeout
	sprite.queue_free()


func _on_piton_game_point_down() -> void:
	armR_animated_sprite_2d.animation = "point_down"
	await get_tree().create_timer(0.3).timeout
	if piton_place:
		armR_animated_sprite_2d.animation = "point"
