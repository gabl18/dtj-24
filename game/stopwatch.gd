extends Control

var time_elapsed := 0.0

var is_stopped := false

func _process(delta: float) -> void:
	if not is_stopped:
		time_elapsed += delta
		$Label.text = str(time_elapsed).pad_decimals(2)

func stop() -> float:
	is_stopped = true
	return time_elapsed
