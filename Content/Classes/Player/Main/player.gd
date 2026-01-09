class_name Player
extends CharacterBody2D

#enum PLAYER_STATES
#{
	#SHOOT,
	#DAMAGED,
	#DEAD
#}


signal _on_player_spawned 	()
signal _on_health_changed	(new_value)
signal _on_mana_changed		(new_value)
signal _on_ability_used		(cooldown_time)
signal _on_player_died		()

# -- Player speed parameter
const SPEED = 300.0
# -- Player server id parameter
var id : int
# -- Player last direction for server movement
var _last_direction : Vector2
# -- Player direction for server movement
var direction : Vector2:
	get: return direction
	set(value):
		if value != direction:
			direction = value
# -- Sync with server global pos
var sync_global_position : Vector2:
	get : return sync_global_position
	set(value):
		if value != sync_global_position:
			global_position = value
			sync_global_position = global_position
# -- Node for animted behaviouir
@export var for_animation_object : AnimatedSprite2D
# -- Node for collision behaviour
@export var for_collision_object : CollisionShape2D

func _ready() -> void:
	add_to_group("Player")
	Signals.PlayerDamaged.connect(get_damage)
	Signals.PlayerKilled.connect(dead)
	var state_machine : Node = preload("uid://18clg5181kcm").instantiate()
	var camera : Node = Camera2D.new()
	camera.zoom.x = 2.0
	camera.zoom.y = 2.0
	add_child(state_machine)
	add_child(camera)

func move(delta : float):
	direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	velocity = (direction * SPEED) if direction else Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
	if direction != _last_direction: 
		_last_direction = direction
		
		var packed_direction : PackedByteArray = [0]
		if direction.x > 0: packed_direction[0] = 128
		if direction.x < 0: packed_direction[0] |= 32
		if direction.y > 0: packed_direction[0] |= 8
		if direction.y < 0: packed_direction[0] |= 2
		print("<Player> : packed direction is ", packed_direction)
		WEBSOCKET.send_byte_binary_data(WEBSOCKET.SEND_COMMAND.PLAYER_DIRECTION, packed_direction)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	print("<Player> : shoot")
	WEBSOCKET.send_binary_data(WEBSOCKET.SEND_COMMAND.PLAYER_SHOOT,[0]) # Мы тупо отправляем на сервер команду стрелять
	

func get_damage(player_id : int, health : int, damage : int):
	if player_id == id:
		print("<Player> : id ", id,  " getted ", damage)

func dead(player_id : int):
	if player_id == id:
		print("<Player> : id ", id,  " dead")
