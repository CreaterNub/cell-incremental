extends Button

func _ready():
	Global.update_values.connect(_on_update_values)

var usable: bool = true

func _on_button_pressed() -> void:
	if Global.Cells.gte(BN.new(1, 6)) and usable == true: # cells > req
		usable = false
		Global.EvolutionPoints = Global.EvolutionPoints.add(Global.PendingEvolutionPoints)
		Global.Cells = BN.new(0, 0)
		Global.CellUpgrade1Purchases = 0
		Global.CellUpgrade2Purchases = 0
		Global.CellUpgrade3Purchases = 0
		Global.update_values.emit() # update values in global script
		usable = true

func _on_update_values():
	if Global.Cells.gte(BN.new(1, 6)):
		$Pending.text = "[color=#00FF00]+ " + str(Global.PendingEvolutionPoints.format()) + " EP[/color]"

	if Global.Cells.lt(BN.new(1, 6)):
		$Pending.text = "[color=#FF0000]Req: " + str(BN.new(1, 6).format()) + " Cells [/color]"
