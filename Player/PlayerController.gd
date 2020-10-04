extends Node


func move(side) -> void:
	if side == "L":
		GLOBAL.Player.movement.move(Vector2.LEFT)
	elif side == "R":
		GLOBAL.Player.movement.move(Vector2.RIGHT)
	else:
		LOG.err("wrong input", "PlayerController::move")
		assert(0)


func jump(multiplier) -> void:
	GLOBAL.Player.movement.jump(multiplier)


func throw(direction:Vector2) -> void:
	pass


func stop() -> void:
	GLOBAL.Player.movement.stop()

func get_dist(direction_string) -> float:
	
	if direction_string.length() == 1:
		var direction = GLOBAL.letter_to_direction[direction_string]
		return GLOBAL.Player.get_dist(direction)
	elif direction_string.length() == 2:
		var direction = GLOBAL.letter_to_direction[direction_string[0]]
		var side = GLOBAL.letter_to_direction[direction_string[1]]
		return GLOBAL.Player.get_dist2(direction, side)
	
	return INF


func on_floor() -> bool:
	return GLOBAL.Player._is_on_floor()
