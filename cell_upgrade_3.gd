extends Button

func _ready():
	Global.update_values.connect(_on_update_values)

var usable: bool = true

func _on_button_pressed() -> void:
	if Global.Cells.gte(Global.CellUpgrade3Cost) and usable == true: # cells > cost
		usable = false
		Global.Cells = BN.new(0, 0)
		Global.CellUpgrade1Purchases = 0
		Global.CellUpgrade3Purchases += 1
		Global.update_values.emit() # update values in global script
		usable = true
		
var buying: bool = false
var loops: int = 0

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if buying == false:
				buying = true
				loops = 0
				while Global.Cells.gte(Global.CellUpgrade3Cost) and loops <= 1000:					
					await get_tree().create_timer(0.02).timeout
					Global.Cells = BN.new(0, 0)
					Global.CellUpgrade1Purchases = 0
					Global.CellUpgrade3Purchases += 1
					Global.update_values.emit()
					loops += 1
				buying = false

func _on_update_values():
	if Global.Cells.gte(Global.CellUpgrade3Cost):
		$Cost.text = "[color=#00FF00]Cost: " + str(Global.CellUpgrade3Cost.format()) + "[/color]"
	$Boost.text = "x" + Global.CellUpgrade3Multi.format() + " power of first Cell Upgrade per level, but reset its purchases alongside Cells"

	if Global.Cells.lt(Global.CellUpgrade3Cost):
		$Cost.text = "[color=#FF0000]Cost: " + str(Global.CellUpgrade3Cost.format()) + "[/color]"
	$Boost.text = "x" + Global.CellUpgrade3Multi.format() + " power of first Cell Upgrade per level, but reset its purchases alongside Cells"
