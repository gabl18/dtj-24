extends StaticBody2D

func reset_size():
	$CollisionShape2D.shape.height = 20
	$CollisionShape2D.shape.radius= 10

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and not event.is_echo():
			$CollisionShape2D.shape.height = 50
			$CollisionShape2D.shape.radius = 15
		elif event.is_released():
			$CollisionShape2D.shape.height = 20
			$CollisionShape2D.shape.radius = 10
