extends Node

onready var player = get_parent()
onready var movement_controller = get_node("../MovementController")

func _process(delta: float) -> void:
	
#	var input_dir := Vector2.ZERO
#	input_dir += Vector2.LEFT * Input.get_action_strength("move_l")
#	input_dir += Vector2.RIGHT * Input.get_action_strength("move_r")
#
#	player.velocity += input_dir.normalized() * player.SPEED
	pass
#	if Input.is_action_just_pressed("jump"):
#		prints("Input Jump")
#		movement_controller.jump()
