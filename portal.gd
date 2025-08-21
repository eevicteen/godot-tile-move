extends Area2D

@export var target_portal: NodePath
@export var exit_offset := Vector2(0, 50)  

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):  
		if target_portal != null:
			var portal = get_node(target_portal)
			if portal:
				var new_pos = portal.global_position + exit_offset

				if body.has_method("teleport_to"):
					body.teleport_to(new_pos)
			else:
				print("DEBUG: Target portal not found at path:", target_portal)
		else:
			print("DEBUG: No target portal assigned!")
