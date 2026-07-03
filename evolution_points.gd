extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		while true: #update text
			await get_tree().create_timer(0.1).timeout
			text = "Evolution Points: " + Global.EvolutionPoints.format() + " (+" + Global.PendingEvolutionPoints.format() + ")"
			if Global.EvolutionPoints.gt(BN.new(0, 0)):
				visible = true
			else:
				visible = false
