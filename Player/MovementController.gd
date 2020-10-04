extends Node

onready var player = get_parent()
onready var jump_timer = $JumpTimer
var can_jump := true
var ct = 0


func move(direction: Vector2) -> void:
	player.velocity += direction * player.SPEED


func stop() -> void:
	player.velocity.x = 0


func jump(multiplier) -> void:
	
	multiplier = clamp(multiplier, 0, 1)

	LOG.pr(0, "jump command [%s]" % player._is_on_floor(),\
	"MovementController::jump")
	
	if player._is_on_floor() and can_jump:
		LOG.pr(0, "JUMP %s" % ct, "MovementController::jump")
		ct += 1
		player.velocity += Vector2.UP * player.jump_strength * multiplier
		can_jump = false
		jump_timer.start(1)



func _on_JumpTimer_timeout() -> void:
	can_jump = true
