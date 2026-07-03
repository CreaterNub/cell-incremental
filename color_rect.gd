extends ColorRect

var hue: float = 0.4
var speed: float = 0.01 # how fast it cycles

func _process(delta: float) -> void:
	hue += speed * delta
	if hue > 1:
		hue -= 1
	
	color = Color.from_hsv(hue, 0.55, 0.5)
