extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var can_show = false
func _on_player_read_sign(id) -> void:
	can_show = not can_show
	if can_show:
		if id == 1:
			text = "Game Tip: Those arrows move you!"
			show()
		if id == 2:
			text = "That chest is purely ornamental."
			show()
		if id == 3:
			text = "I love computer science (lie)"
			show()
		if id == 4:
			text = "I'm running out of ideas"
			show()
	else:
		hide()
