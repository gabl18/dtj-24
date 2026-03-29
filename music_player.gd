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
	
const CLICK = preload("uid://c1fisddw5jm1n")
const PARTY_HORN = preload("uid://7b41saad6868")
const STONE_2 = preload("uid://c12ofgp1dtyq6")
const STONE_3 = preload("uid://dr25olitudpqr")
const STONE_4 = preload("uid://bisux643qgly5")
const STONE_5 = preload("uid://b4nm4gvgcpu2y")
const STONE = preload("uid://by1xy4qg1o1sm")

func get_random_stone_noise():
	return [STONE,STONE_2,STONE_3,STONE_4,STONE_5].pick_random()
