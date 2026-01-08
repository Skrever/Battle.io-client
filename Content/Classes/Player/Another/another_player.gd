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
