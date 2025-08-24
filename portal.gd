extends Area2D

@export var target_portal: Node2D
var overlapping_player: Node = null

func _ready() -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		overlapping_player = body

func _on_body_exited(body: Node) -> void:
	overlapping_player = null

func _process(_delta: float) -> void:
	if overlapping_player and Input.is_action_just_pressed("interact"):
		teleport_player(overlapping_player)


func teleport_player(body: Node) -> void:
	if target_portal and body.has_method("teleport_to"):
		body.teleport_to(target_portal.global_position)
		overlapping_player = null

 
