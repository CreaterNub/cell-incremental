extends Camera2D

var dragging: bool = false

var mouse_pos = 0
var prev_mouse_pos = 0

var min_zoom: float = 0.2
var max_zoom: float = 1

const zoom_speed: float = 0.15


func clamp_camera():
	if position.length() > 50000:
		position = position.normalized() * 50000


func _input(event):  # runs whenever any input happens

	# Start dragging when mouse released
	if event.is_action_pressed("camera_pan"):
		dragging = true
		
	# Stop dragging when mouse released
	elif event.is_action_released("camera_pan"):
		dragging = false

	# Move camera while dragging with mouse
	elif event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom
		clamp_camera()

	elif event.is_action_pressed("zoom_in"):

		prev_mouse_pos = get_global_mouse_position()

		zoom *= (1.0 - zoom_speed)

		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)

		mouse_pos = get_global_mouse_position()

		position += prev_mouse_pos - mouse_pos
		clamp_camera()

		
	elif event.is_action_pressed("zoom_out"):

		prev_mouse_pos = get_global_mouse_position()

		zoom *= (1.0 + zoom_speed)

		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)

		mouse_pos = get_global_mouse_position()

		position += prev_mouse_pos - mouse_pos
		clamp_camera()
		
	elif event.is_action_pressed("reset_camera"):
		position = Vector2(0, 0)
