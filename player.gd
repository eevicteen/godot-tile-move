extends CharacterBody2D

var moving = false
var direction
var input_locked := false

var path_layer : TileMapLayer
var wall_layer : TileMapLayer
var forced_layer : TileMapLayer
var sign_layer: TileMapLayer
var current_cell
var target_cell
var can_move = true
signal read_sign()

func _ready() -> void:
	path_layer = get_node("../TileMap/PathLayer")
	wall_layer = get_node("../TileMap/WallLayer")
	forced_layer = get_node("../TileMap/ForcedLayer")
	sign_layer = get_node("../TileMap/SignIDLayer")

func _process(delta: float) -> void:
	if input_locked:
		return   
	direction = Vector2i.ZERO
	current_cell = wall_layer.local_to_map(position)
	
	var sign_cell_data = sign_layer.get_cell_tile_data(current_cell)
	
	if can_move:
		if Input.is_action_pressed("ui_right"):
			direction = Vector2i.RIGHT
			move("side")
		elif Input.is_action_pressed("ui_left"):
			direction = Vector2i.LEFT
			move("side")
		elif Input.is_action_pressed("ui_down"):
			direction = Vector2i.DOWN
			move("down")
		elif Input.is_action_pressed("ui_up"):
			direction = Vector2i.UP
			move("up")
	
	if Input.is_action_just_pressed("ui_accept") and moving == false:
		if sign_cell_data:
			var sign_id = sign_cell_data.get_custom_data("sign_id")
			read_sign.emit(sign_id)
			can_move=not can_move
	
	
func stop_moving():
	moving = false
	
	var forced_tile_data = forced_layer.get_cell_tile_data(current_cell)
	
	if forced_tile_data:
		direction = forced_tile_data.get_custom_data("forced_dir")
		if can_move_to(current_cell+direction):	
			move(vector_to_animation_sprite(direction))
		else:
			$AnimatedSprite2D.animation = vector_to_animation_sprite(direction)
			$AnimatedSprite2D.stop()
		return
	
	if not (Input.is_action_pressed("ui_right") or
			Input.is_action_pressed("ui_left") or
			Input.is_action_pressed("ui_down") or
			Input.is_action_pressed("ui_up")):
		$AnimatedSprite2D.stop()

func move(sprite_type):
	var target_cell = current_cell + direction
	if not moving:
		$AnimatedSprite2D.animation = sprite_type
		$AnimatedSprite2D.flip_h = direction.x <0
		if can_move_to(target_cell):
			if not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play()
			moving = true
			var tween = create_tween()
			tween.tween_property(self,"position",wall_layer.map_to_local(target_cell),0.25)
			tween.tween_callback(stop_moving)
		elif (not can_move_to(target_cell)):
			$AnimatedSprite2D.stop()	
		
func can_move_to(cell):
	var cell_id = wall_layer.get_cell_source_id(cell)
	return cell_id == -1

func vector_to_animation_sprite(vec):
	if vec==Vector2i.RIGHT or vec ==Vector2i.LEFT:	
		return("side")
	elif vec == Vector2i.DOWN:
		return("down")
	elif vec == Vector2i.UP:
		return("up")
	else:
		pass

func teleport_to(new_pos: Vector2) -> void:
	global_position = new_pos
	input_locked = true
	await get_tree().process_frame 
	input_locked = false
