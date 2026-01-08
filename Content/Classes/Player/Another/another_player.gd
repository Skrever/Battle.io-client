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
	pass #эта функция служит как заглушка, потому что этот класс наследуется от обычного игрока
	# надо сделать так, чтобы оба класса Player и Another наследовались от одного, а не Another от Player
	# Да, по факту анимацию стрельбы тупо не к чему привязывать пока тут в Another, потому что нет такого сигнала, который бы дошёл от сервера.


# можно накинуть анимацию
func get_damage(player_id : int, health : int, damage : int):
	if player_id == id:
		print("<Player> : id ", id,  " getted ", damage)
# можно накинуть анимацию
func dead(player_id : int):
	if player_id == id:
		print("<Player> : id ", id,  " dead")
