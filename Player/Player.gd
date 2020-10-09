extends KinematicBody2D

var MAX_DIST = 10000.0

var GRAVITY := 600.0
var SLOW := 2.0

var MAX_VELOCITY := 100.0
var SPEED := 60.0
var jump_strength := 250.0

var velocity := Vector2.ZERO

onready var movement = $MovementController
onready var queue = $PositionQueue
var ray_parent = "Rays/"


func _ready() -> void:
	GLOBAL.Player = self
	add_to_group("should_reset")


func reset() -> void:
	LOG.pr(2, "Player RESET", "Player::reset")


func _physics_process(delta: float) -> void:
#	if _is_on_floor():
#		velocity.y = 0
#	else:
#	velocity.y += GRAVITY*delta
#
#	if abs(velocity.x) > SLOW:
#		if velocity.x > 0:
#			velocity.x -= SLOW
#		else:
#			velocity.x += SLOW
#	else:
#		velocity.x = 0
#
#	velocity.x = clamp(velocity.x, -MAX_VELOCITY, MAX_VELOCITY)

	if velocity.x != 0.0:
		velocity.x = (velocity.x / (abs(velocity.x))) * SPEED
	
#	var old_vel_y :float= velocity.y
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
#	velocity = move_and_slide(velocity, Vector2.UP)
#	velocity = move_and_slide(Vector2(velocity.x, (velocity.y + old_vel_y) / 2.0), Vector2.UP)
	
	queue.push(position.y)

	velocity.x = 0


func _is_on_floor() -> bool:
#	prints("distance to floor: [%s] <=? [%s]"\
# % [get_dist(GLOBAL.DIRECTION.DOWN), $Sprite.get_rect().size.x / 2 + 0.01])

#	LOG.pr(2, "is_on_floor:%s"%(get_dist(GLOBAL.DIRECTION.DOWN) <= 0.01), "Player::_is_on_floor")
	return (get_dist(GLOBAL.DIRECTION.DOWN) <= 0.01)
#	 or queue.is_same()



func get_dist(direction:int) -> float:
	var rname = "%sRay%s" % [ray_parent, GLOBAL.direction_name[direction]]
	var ray = get_node(rname)
	
	if ray.is_colliding():
		var hit = ray.get_collision_point()
		return ray.global_position.distance_to(hit)

	return MAX_DIST


func get_dist2(direction:int, side:int) -> float:
	var rname = "%sRay%s%s"\
	% [ray_parent ,GLOBAL.direction_name[direction], GLOBAL.direction_to_letter[side]]
	
	var ray = get_node(rname)
	
	if ray.is_colliding():
		var hit = ray.get_collision_point()
		return ray.global_position.distance_to(hit)

	return MAX_DIST


func get_pos(direction:int):
	var rname = "%sRay%s" % [ray_parent, GLOBAL.direction_name[direction]]
	var ray = get_node(rname)
	
	if ray.is_colliding():
		return ray.get_collision_point()

	return null


func get_pos2(direction:int, side:int):
	var rname = "%sRay%s%s"\
	% [ray_parent ,GLOBAL.direction_name[direction], GLOBAL.direction_to_letter[side]]
	
	var ray = get_node(rname)
	
	if ray.is_colliding():
		return ray.get_collision_point()
	return null



func _on_death() -> void:
	LOG.pr(2, "Player died", "Player::_on_death")
	GLOBAL.reset_game()



func _on_Hurtbox_body_entered(body: Node) -> void:
	_on_death()
