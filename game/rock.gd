extends StaticBody2D

func reset_size():
	change_sprite()


func change_sprite():
	$Sprite2D.frame = randi_range(0,4)
	
