tool
extends Node2D

const bullet_prefab = preload("res://Levels/GameObjects/Turret/Bullet/Bullet.tscn")


enum DIRECTION {
	UP = 0,
	DOWN,
	LEFT,
	RIGHT
}

const enum_to_vec2 = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]


export(Color) var group_color = Color.white setget set_color, get_color
export(DIRECTION) var direction = DIRECTION.RIGHT setget set_dir, get_dir
export(float) var ATTACKS_PER_SECOND = 1.0
export(float) var BULLET_SPEED = 10.0
export(float) var editor_trajectory_length = 100.0 setget set_tra_len, get_tra_len
export(float) var editor_trajectory_thickness = 1.2 setget set_tra_thick, get_tra_thick

var dotted := true
const dot_len := 5.0
const empty_len := 2.0

func _ready() -> void:
	
	if not Engine.editor_hint:
		$AttackTimer.wait_time = 1.0 / ATTACKS_PER_SECOND
		$AttackTimer.start()


func _draw() -> void:
	
	if Engine.editor_hint:
		
		if dotted:
			var current_len = 0
			var current_point = Vector2.ZERO
			
			while(current_len < editor_trajectory_length):
				
				draw_line(current_point,\
				current_point+\
				enum_to_vec2[DIRECTION.RIGHT]*dot_len,\
				group_color.lightened(0.2), editor_trajectory_thickness)
				
				current_point += enum_to_vec2[DIRECTION.RIGHT]*\
				(dot_len+empty_len)
				
				current_len += dot_len+empty_len
			
			pass
		else:
			draw_line(Vector2.ZERO,\
			enum_to_vec2[DIRECTION.RIGHT]*editor_trajectory_length,\
			group_color.lightened(0.2), editor_trajectory_thickness)

#func _process(delta: float) -> void:
#
#	if Engine.editor_hint:
#		update()
#		pass

func set_tra_len(length) -> void:
	editor_trajectory_length = length
	update()


func get_tra_len():
	return editor_trajectory_length


func set_tra_thick(thick) -> void:
	editor_trajectory_thickness = thick
	update()


func get_tra_thick():
	return editor_trajectory_thickness


func set_color(color) -> void:
	if Engine.editor_hint:
		$Sprite.modulate = color


func get_color() -> Color:
	if Engine.editor_hint:
		return $Sprite.modulate
	return Color.white


func set_dir(dir) -> void:
	direction = dir
	if is_inside_tree():
		look_at(global_position + enum_to_vec2[direction] * 100.0)


func get_dir():
	return direction


func _on_AttackTimer_timeout() -> void:
	if not Engine.editor_hint:
		
		var new_bullet = bullet_prefab.instance()
		add_child(new_bullet)
		new_bullet.init(enum_to_vec2[direction], BULLET_SPEED)
		new_bullet.activate()
