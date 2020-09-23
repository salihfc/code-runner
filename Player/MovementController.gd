extends Node

onready var player = get_parent()

func move(direction: Vector2) -> void:
	player.velocity += direction * player.SPEED

func jump(multiplier) -> void:
	
	prints("jump command [%s]" % player.is_on_floor())
	if player.is_on_floor():
		prints("player jumping")
		player.velocity += Vector2.UP * player.jump_strength * multiplier
	
