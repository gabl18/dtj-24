extends Node2D

@onready var border_anim_player: AnimationPlayer = $Border/AnimationPlayer
@onready var countdown_anim_player: AnimationPlayer = $Countdown/AnimationPlayer


@onready var shoutouts: Sprite2D = $Shoutouts

signal win

enum games {
	rockgame,
	rope,
	untangle,
	chalk,
	piton,
	compass,
}

@onready var climb_timer: Timer = $ClimbTimer

@onready var rock_game: Node2D = $RockGame
@onready var rope_game: Node2D = $RopeGame
@onready var untangle_game: Node2D = $UntangleGame
@onready var chalk_game: Node2D = $ChalkGame
@onready var piton_game: Node2D = $PitonGame
@onready var compass_game: Node2D = $CompassGame

@export var goal_height = 100
var prev_game
var active_game := games.rockgame

var height: float
var won: bool = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	climb_timer.start()
	armL_animated_sprite_2d.animation = "open"
	armR_animated_sprite_2d.animation = "open"
	
	MusicPlayer.music.stream = MusicPlayer.MAIN
	MusicPlayer.music.play()


func change_game():
	hand_is_closed = false
	_disable_game()
	if not active_game == games.rockgame:
		countdown_anim_player.play("coundown")
		
		MusicPlayer.music.stream = MusicPlayer.get_random_mini_track()
		MusicPlayer.music.play()
		
		_play_game_trans_in()
		border_anim_player.play("trans_in")
		await get_tree().create_timer(1).timeout
	else:
		MusicPlayer.music.stream = MusicPlayer.MAIN
		MusicPlayer.music.play()
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
	
	if active_game != games.compass:
		compass_game.disable()


func _enable_game():
	if active_game == games.rockgame:
		rock_game.enable()
		rock_game.modulate = Color(1.0, 1.0, 1.0, 1.0)
		climb_both_hands = true

	if active_game == games.rope:
		rope_game.enable()
		_show_shoutout(5)

	if active_game == games.untangle:
		untangle_game.enable()
		_show_shoutout(7)
	
	if active_game == games.chalk:
		chalk_game.enable()
		_show_shoutout(3)
	
	if active_game == games.piton:
		piton_game.enable()
		_show_shoutout(3)
	
	if active_game == games.compass:
		compass_game.enable()
		_show_shoutout(6)

func _play_game_trans_in():
	if active_game == games.rope:
		rope_game.play_trans_in_anim()
		climb_rope = true
		
		
	if active_game == games.untangle:
		untangle_game.play_trans_in_anim()
		rope_untangle = true
		armR_animated_sprite_2d.animation = "open"
		
		
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

	if active_game == games.compass:
		
		piton_place = true
		
		armR_animated_sprite_2d.animation = "point"
		var tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(-50,250),0.4)
		await tween.finished
		tween.kill()
		armL_animated_sprite_2d.animation = "compass"
		tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(550,350),0.5)
		await tween.finished
		tween.kill()


func _play_minigame() -> void:
	while true:
		active_game = randi_range(1,5) as games
		if active_game != prev_game:
			break
	prev_game = active_game
	change_game()


func _finished_minigame():
	border_anim_player.play("trans_out")
	active_game = games.rockgame
	change_game()
	climb_timer.start()


@onready var armR: Node2D = $ArmR
@onready var armL: Node2D = $ArmL

@onready var armR_palm: AnimatedSprite2D = $ArmR/Palm
@onready var armL_palm: AnimatedSprite2D = $ArmL/Palm

@onready var armR_animated_sprite_2d: AnimatedSprite2D = $ArmR/Palm
@onready var armL_animated_sprite_2d: AnimatedSprite2D = $ArmL/Palm

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
					armL_palm.global_position.x = (mouse_pos.x - armL_palm.global_position.x) * 0.5 + armL_palm.global_position.x
				armL_palm.global_position.y = (mouse_pos.y - armL_palm.global_position.y) * 0.5 + armL_palm.global_position.y
				armL.z_index = 1
				armR.z_index = 0

			else:
				if not hand_is_closed:
					armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.5 + armR_palm.global_position.x
				armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.5 + armR_palm.global_position.y
				armR.z_index = 1
				armL.z_index = 0
	
	elif climb_rope:
		if hand_is_active:
			if active_hand_is_L:
				if not hand_is_closed:
					armL_palm.global_position.x = clamp((mouse_pos.x - armL_palm.global_position.x) * 0.7 + armL_palm.global_position.x, 0, get_viewport_rect().size.x/2)
				armL_palm.global_position.y = (mouse_pos.y - armL_palm.global_position.y) * 0.7 + armL_palm.global_position.y
				armL.z_index = 1
				armR.z_index = 0

			else:
				if not hand_is_closed:
					armR_palm.global_position.x = clamp((mouse_pos.x - armR_palm.global_position.x) * 0.7 + armR_palm.global_position.x, get_viewport_rect().size.x/2, get_viewport_rect().size.x)
				armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.7 + armR_palm.global_position.y
				armR.z_index = 1
				armL.z_index = 0
	
	elif rope_untangle:
		if hand_is_active:
			armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.9 + armR_palm.global_position.x
			armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.9 + armR_palm.global_position.y
			armR.z_index = 1
			armL.z_index = 0
			
	elif chalk_bag:
		if hand_is_active:
			armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.7 + armR_palm.global_position.x
			armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.7 + armR_palm.global_position.y
			armR.z_index = 1
			armL.z_index = 0
	
	elif piton_place:
		if hand_is_active:
			armR_palm.global_position.x = (mouse_pos.x - armR_palm.global_position.x) * 0.7 + armR_palm.global_position.x
			armR_palm.global_position.y = (mouse_pos.y - armR_palm.global_position.y) * 0.7 + armR_palm.global_position.y
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

const PITON = preload("uid://byt2wiakne7e3")


func _on_piton_game_minigame_finished() -> void:
	var inst = PITON.instantiate()
	rock_game.rocks.add_child(inst)
	inst.connect("mouse_entered",rock_game._rock_mouse_entered)
	inst.connect("mouse_exited",rock_game._rock_mouse_exited)
	inst.connect("input_event",rock_game._rock_input_event)
	inst.global_position = piton_game.get_child(0).global_position
	await get_tree().create_timer(20).timeout
	inst.queue_free()


func _on_piton_game_point_down() -> void:
	armR_animated_sprite_2d.animation = "point_down"
	await get_tree().create_timer(0.3).timeout
	if piton_place:
		armR_animated_sprite_2d.animation = "point"


func _on_rock_game_height_updated(h: float) -> void:
	height = h / 300
	$ProgressBar.value = height/goal_height
	if height >= goal_height:
		_final_minigame()
		
@onready var finale: Sprite2D = $RockGame/Rocks/Finale

func _final_minigame():
	if not won:
		climb_timer.stop()
		finale.global_position.y = -600
		finale.show()
		MusicPlayer.music.stream = MusicPlayer.MINI_4
		MusicPlayer.music.play()
	won = true
	
	if height >= goal_height + 0.3:
		rock_game.won = true
		
		await get_tree().create_tween().tween_property(rock_game,"height",-finale.position.y,4).finished
		%Wheel.enable()
		climb_both_hands = false
		piton_place = true
		armR_animated_sprite_2d.animation = "point"
		win.emit()
		
		var tween = get_tree().create_tween()
		tween.tween_property(armL_palm,"global_position",Vector2(-50,450),0.4)
		await tween.finished
		tween.kill()

func _on_compass_game_minigame_finished() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(armL_palm,"global_position",Vector2(-50,250),0.4)
	await tween.finished
	tween.kill()
	armL_animated_sprite_2d.animation = "open"


func _on_wheel_winwin() -> void:
	var time = %Stopwatch.stop()
	await get_tree().create_timer(5).timeout
	get_tree().get_first_node_in_group("main").game_done(time)
	
