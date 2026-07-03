extends Button

func _ready():
	Global.update_values.connect(_on_update_values)

var usable: bool = true

func _on_button_pressed() -> void:
	if Global.EvolutionPoints.gte(Global.EvolutionUpgrade1Cost) and usable == true: # EP > cost
		usable = false
		Global.EvolutionPoints.subtract(Global.EvolutionUpgrade1Cost)
		Global.EvolutionUpgrade1Purchases += 1
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
				while Global.EvolutionPoints.gte(Global.EvolutionUpgrade1Cost) and loops <= 1000:					
					await get_tree().create_timer(0.02).timeout
					Global.EvolutionPoints.subtract(Global.EvolutionUpgrade1Cost)
					Global.EvolutionUpgrade1Purchases += 1
					Global.update_values.emit()
					loops += 1
				buying = false

func _on_update_values():
	if Global.EvolutionPoints.gte(Global.EvolutionUpgrade1Cost):
		$Cost.text = "[color=#00FF00]Cost: " + str(Global.EvolutionUpgrade1Cost.format()) + "[/color]"
	$Boost.text = "x" + Global.EvolutionUpgrade1Multi.format() + " Cells per level"

	if Global.EvolutionPoints.lt(Global.EvolutionUpgrade1Cost):
		$Cost.text = "[color=#FF0000]Cost: " + str(Global.EvolutionUpgrade1Cost.format()) + "[/color]"
	$Boost.text = "x" + Global.EvolutionUpgrade1Multi.format() + " Cells per level"
