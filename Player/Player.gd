extends KinematicBody2D

var GRAVITY := 600.0
var SLOW := 2.0

var MAX_VELOCITY := 100.0
var SPEED := 60.0
var jump_strength := 220.0

var velocity := Vector2.ZERO

onready var movement = $MovementController

func _ready() -> void:
	GLOBAL.Player = self

func _physics_process(delta: float) -> void:
#	if is_on_floor():
#		velocity.y = 0
#	else:
	velocity.y += GRAVITY*delta

	if abs(velocity.x) > SLOW:
		if velocity.x > 0:
			velocity.x -= SLOW
		else:
			velocity.x += SLOW
	else:
		velocity.x = 0

	velocity.x = clamp(velocity.x, -MAX_VELOCITY, MAX_VELOCITY)

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN)




func is_on_floor() -> bool:
#	prints("distance to floor: [%s] <=? [%s]" % [get_dist(GLOBAL.DIRECTION.DOWN), $Sprite.get_rect().size.x / 2 + 0.01])
	return get_dist(GLOBAL.DIRECTION.DOWN) <= ($Sprite.get_rect().size.x / 2 + 0.01)
	

func get_dist(direction:int) -> float:
	var rname = "Ray%s" % GLOBAL.direction_name[direction]
	var ray = get_node(rname)
	
	if ray.is_colliding():
		return global_position.distance_to(ray.get_collision_point())

	return INF
