tool
extends Node2D

enum DOOR_COLOR {
	WHITE,
	BLACK,

	RED,
	GREEN,
	BLUE,

	YELLOW,
	ORANGE,
	PINK,
	MAGENTA,
	CYAN,
}

var COLOR_ARRAY = [
	Color.white,
	Color.black,

	Color.red,
	Color.green,
	Color.blue,

	Color.yellow,
	Color.orange,
	
	Color.pink,
	Color.magenta,
	Color.cyan,
]


export(DOOR_COLOR) var group_color = DOOR_COLOR.WHITE\
setget set_color, get_color


func set_color(col):
	group_color = col
	$Sprite.modulate = COLOR_ARRAY[group_color]


func get_color():
	return group_color


func _ready() -> void:
	add_to_group("linked_" + String(group_color))
	$Sprite.modulate = COLOR_ARRAY[group_color]


func dissipate() -> void:
	$AnimationPlayer.play("Dissipate")
	
	$Tween.interpolate_method(self, "set_diss_level", 0, 1, 0.3)


func set_diss_level(f : float) -> void:
#	$Sprite.
	pass
