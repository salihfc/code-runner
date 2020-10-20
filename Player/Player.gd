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
	add_to_group("player")


func reset() -> void:
	LOG.pr(2, "Player RESET", "Player::reset")


func _physics_process(delta: float) -> void:

	if velocity.x != 0.0:
		velocity.x = (velocity.x / (abs(velocity.x))) * SPEED
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	queue.push(position.y)

	velocity.x = 0


func _is_on_floor() -> bool:
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
	% [
	ray_parent,
	GLOBAL.direction_name[direction], 
	GLOBAL.direction_to_letter[side]]
	
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
	% [
	ray_parent,
	GLOBAL.direction_name[direction],
	GLOBAL.direction_to_letter[side]]
	
	var ray = get_node(rname)
	
	if ray.is_colliding():
		return ray.get_collision_point()
	return null



func _on_death() -> void:
	LOG.pr(2, "Player died", "Player::_on_death")
	GLOBAL.reset_game()



func _on_Hurtbox_body_entered(body: Node) -> void:
	LOG.pr(2, "body:[%s] killed player" % body,\
	"Player::_on_Hurtbox_body_entered")
	
	_on_death()


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	LOG.pr(2, "area:[%s] killed player" % area,\
	"Player::_on_Hurtbox_area_entered")
	
	_on_death()
