extends CharacterBody2D

@export var speed: float = 100.0

var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	elif Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalize so diagonal isn’t faster
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
		_play_animation(direction)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

	move_and_slide()


func _play_animation(dir: Vector2) -> void:
	if dir.y > 0:
		$AnimatedSprite2D.animation = "down"
	elif dir.y < 0:
		$AnimatedSprite2D.animation = "up"
	else:
		$AnimatedSprite2D.animation = "side"
		$AnimatedSprite2D.flip_h = dir.x < 0
	
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play()
