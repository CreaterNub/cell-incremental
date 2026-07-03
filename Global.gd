extends Node

signal update_values # triggered when upg is bought, and recaculates values

func _ready():
	update_values.connect(_on_update_values)
	while true:
		await get_tree().create_timer(0.1).timeout
		Global.update_values.emit()

# Cell variables
var Cells: BN = BN.new(0, 0) # 0
var CellValue: BN = BN.new(1, 0) # 1/s

var CellUpgrade1Cost: BN = BN.new(1, 1) # 10
var CellUpgrade1Multi: BN = BN.new(0.5, 0) # +0.5x
var CellUpgrade1Purchases: float = 0

var CellUpgrade2Cost: BN = BN.new(1, 2) # 100
var CellUpgrade2Multi: BN = BN.new(1.5, 0) # x1.5
var CellUpgrade2Purchases: float = 0

var CellUpgrade3Cost: BN = BN.new(1, 3) # 1K
var CellUpgrade3Multi: BN = BN.new(1.66, 0) # x1.66
var CellUpgrade3Purchases: float = 0

# Evolution Variables
var PendingEvolutionPoints: BN = BN.new(1, 0) # 1
var EvolutionPoints: BN = BN.new(0, 0) # 0

var EvolutionUpgrade1Cost: BN = BN.new(1, 0) #1
var EvolutionUpgrade1Multi: BN = BN.new(2, 0) # 2x
var EvolutionUpgrade1Purchases: float = 0


var TimeScale: float = 1 # lower = slower. 1 = default


# Recaculate value when an upg is bought and every now then
func _on_update_values():
	# Reset stuff first
	CellValue = BN.new(1, 0)
	CellUpgrade1Multi = BN.new(0.5, 0)
	
	# Update stuff
	# Cell Upgrades
	CellUpgrade1Multi = CellUpgrade1Multi.multiply(CellUpgrade3Multi.pow(CellUpgrade3Purchases))
	CellUpgrade1Cost = BN.new(1, 1).multiply(BN.new(1.25 + ((CellUpgrade1Purchases/80)), 0).pow(CellUpgrade1Purchases))
	if CellUpgrade1Cost.gte(BN.new(1, 5)):
		CellUpgrade1Cost = CellUpgrade1Cost.multiply(BN.new(1.1 + (((CellUpgrade1Purchases - 8)/100)), 0).pow(CellUpgrade1Purchases))

	
	CellUpgrade2Multi = BN.new(1.5, 0)
	CellUpgrade2Cost = BN.new(1, 2).multiply(BN.new(1.55 + ((CellUpgrade2Purchases/35)), 0).pow(CellUpgrade2Purchases))
	if CellUpgrade2Cost.gte(BN.new(1, 6)):
			CellUpgrade2Cost = CellUpgrade2Cost.multiply(BN.new(1.2 + (((CellUpgrade2Purchases - 5)/16)), 0).pow(CellUpgrade2Purchases))

	CellUpgrade3Multi = BN.new(1.66, 0)
	CellUpgrade3Cost = BN.new(1, 3).multiply(BN.new(3 + ((CellUpgrade3Purchases/3)), 0).pow(CellUpgrade3Purchases))
	if CellUpgrade3Cost.gte(BN.new(1, 5)):
		CellUpgrade3Cost = CellUpgrade3Cost.multiply(BN.new(2 + (((CellUpgrade3Purchases - 2)/8)), 0).pow(CellUpgrade3Purchases))

	# Evolution
	var temp_cells = Cells.copy()
	PendingEvolutionPoints = temp_cells.divide(BN.new(1, 6)).pow(0.5)	
	EvolutionUpgrade1Multi = BN.new(2, 0)
	EvolutionUpgrade1Cost = BN.new(1, 0).multiply(BN.new(3, 0).pow(EvolutionUpgrade1Purchases))
	if EvolutionUpgrade1Cost.gte(BN.new(5, 1)):
		EvolutionUpgrade1Cost = EvolutionUpgrade1Cost.multiply(BN.new(1.2 + ((EvolutionUpgrade1Purchases/12)), 0).pow(EvolutionUpgrade1Purchases))
		if EvolutionUpgrade1Cost.gte(BN.new(1, 8)):
			EvolutionUpgrade1Cost = EvolutionUpgrade1Cost.multiply(BN.new(1.5 + ((EvolutionUpgrade1Purchases/8)), 0).pow(EvolutionUpgrade1Purchases))


	# update cell value (additive, then multiplicative)
	CellValue = CellValue.add(CellUpgrade1Multi.multiply(BN.new(CellUpgrade1Purchases)))
	# multis
	CellValue = CellValue.multiply(CellUpgrade2Multi.pow(CellUpgrade2Purchases))
	CellValue = CellValue.multiply(EvolutionUpgrade1Multi.pow(EvolutionUpgrade1Purchases))
	
	# Other stuff
	CellUpgrade1Multi = BN.new(0.5, 0)
	CellUpgrade1Multi = CellUpgrade1Multi.multiply(CellUpgrade3Multi.pow(CellUpgrade3Purchases))
	CellUpgrade2Multi = BN.new(1.5, 0)
	CellUpgrade3Multi = BN.new(1.66, 0)
	EvolutionUpgrade1Multi = BN.new(2, 0)

	
