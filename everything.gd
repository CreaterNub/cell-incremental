extends Node2D

@onready var CellUpg1Text = $CellUpgrades/CellUpgrade1/Text

func _ready():
	Global.set_cell_label(CellUpg1Text)
