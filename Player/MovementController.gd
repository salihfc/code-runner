extends Node

onready var player = get_parent()
onready var jump_timer = $JumpTimer

var ct = 0

func move(direction: Vector2) -> void:
	player.velocity += direction * player.SPEED

func jump(multiplier) -> void:
	
	multiplier = clamp(multiplier, 0, 1)

#	prints("jump command [%s]" % player.is_on_floor())
	if player.is_on_floor() and jump_timer.is_stopped():
		prints("JUMP %s", ct)
		ct += 1
		player.velocity += Vector2.UP * player.jump_strength * multiplier
		jump_timer.start(1)
