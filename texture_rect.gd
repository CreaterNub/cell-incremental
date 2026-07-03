extends TextureRect

var angle: float = 0.0
var speed: float = 0.2 # radians per second
var radius: float = 500.0

func _ready() -> void:
	size = Vector2(100000, 100000)
	position = Vector2(-50000, -50000)

func _process(delta: float) -> void:
	angle += speed * delta

	var center := Vector2(
		cos(angle),
		sin(angle)
	) * radius

	position = center - size / 2
