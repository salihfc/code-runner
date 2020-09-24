extends Node


func move(side) -> void:
	if side == "L":
		GLOBAL.Player.movement.move(Vector2.LEFT)
	elif side == "R":
		GLOBAL.Player.movement.move(Vector2.RIGHT)
	else:
		prints("wrong input PlayerController::move")
		assert(0)


func jump(multiplier) -> void:
	GLOBAL.Player.movement.jump(multiplier)


func throw(direction:Vector2) -> void:
	pass


func get_dist(direction_string) -> float:
	var direction = GLOBAL.letter_to_direction[direction_string]
	return GLOBAL.Player.get_dist(direction)
