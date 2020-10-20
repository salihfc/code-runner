extends KinematicBody2D

var direction:Vector2
var velocity:float
var moving := false
var collision

func _ready() -> void:
#	set_as_toplevel(true)
	pass

func init(dir, vel):
	direction = dir
	velocity = vel


func activate():
	 moving = true


func _physics_process(delta: float) -> void:
	if is_inside_tree():
		var calculated_velocity = velocity * direction.normalized()
		calculated_velocity *= int(moving)
		collision = move_and_collide(calculated_velocity)
	
	if collision:
		collision_mask = 0
		collision_layer = 0
		call_deferred("queue_free")
		
		if collision.get_collider().is_in_group("player"):
			GLOBAL.reset_game()
