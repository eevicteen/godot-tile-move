extends Label

var sign_texts := {
	1: "Game Tip: Those arrows move you!",
	2: "That chest is purely ornamental.",
	3: "I love computer science (lie)",
	4: "I'm running out of ideas"
}

signal close_sign()


func _ready() -> void:
	hide()


func _on_player_read_sign(id: int) -> void:
	if is_visible():
		hide()
		emit_signal("close_sign")
	else:
		text = sign_texts.get(id)
		show()
