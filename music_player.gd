extends Node

@onready var sfx: AudioStreamPlayer = %SFX
@onready var music: AudioStreamPlayer = %Music

const MAIN = preload("uid://ytyoymxutedu")
const MINI_1 = preload("uid://cmij6ls0pncso")
const MINI_2 = preload("uid://2b1cm6t2g3pc")
const MINI_3 = preload("uid://ciiessa0bw1os")
const MINI_4 = preload("uid://buhvq2tntd7xx")

func get_random_mini_track():
	return [MINI_1,MINI_2,MINI_3].pick_random()
