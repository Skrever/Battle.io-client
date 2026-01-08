class_name Player
extends CharacterBody2D

#Это надо добавить в лучшей жизни. Инкапсуляцию данных он захотел, дададададад
#enum PLAYER_STATES
#{
	#SHOOT,
	#DAMAGED,
	#DEAD
#}

const SPEED = 300.0
var id : int
var _last_direction : Vector2
var direction : Vector2:
	get: return direction
	set(value):
		if value != direction:
			direction = value
var sync_global_position : Vector2:
	get : return sync_global_position
	set(value):
		if value != sync_global_position:
			global_position = value
			sync_global_position = global_position

func _ready() -> void:
	add_to_group("Player")
	Signals.PlayerDamaged.connect(get_damage)
	Signals.PlayerKilled.connect(dead)

func _physics_process(delta: float) -> void:
	move(delta)

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
	WEBSOCKET.send_binary_data(WEBSOCKET.SEND_COMMAND.PLAYER_SHOOT,[0])
	
func get_damage(id : int, health : int, damage : int):
	print("<Player> : id ", id,  " getted ", damage)
	
func dead(id : int):
	print("<Player> : id ", id,  " dead")
