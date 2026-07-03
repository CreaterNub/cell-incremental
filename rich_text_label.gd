extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		while true: #update text
			await get_tree().create_timer(0.1).timeout
			text = "Cells: " + Global.Cells.format() + " (+" + Global.CellValue.format() + "/s)"

# Calls every frame. delta is time since last frame.
func _process(delta: float) -> void:
	var gain = Global.CellValue.copy() #make a copy of cell value so it doesnt decay
	
	gain.mul_float(delta) # make it equal on any fps

	gain.mul_float(Global.TimeScale)
	Global.Cells.add(gain) # change Cells by cell value (gain)
