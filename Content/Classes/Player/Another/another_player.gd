class_name AnotherPlayer
extends Player


func _ready() -> void:
	add_to_group("AnotherPlayer")

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta : float):
	velocity = (direction * SPEED) if direction else Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
	move_and_slide()

func shoot():
	pass 


func get_damage(player_id : int, health : int, damage : int):
	if player_id == id:
		print("<Player> : id ", id,  " getted ", damage)
		
func dead(player_id : int):
	if player_id == id:
		print("<Player> : id ", id,  " dead")
