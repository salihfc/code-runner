extends Node2D

onready var tex = preload("res://assets/game/red_4x4.png")
onready var parent = get_parent()

var ray_names = [
	"U" ,
	"L" ,
	"R" ,
	"D" ,
	
	"UL",
	"UR",

	"DL",
	"DR",
	
	"LU",
	"LD",

	"RU",
	"RD",
]

var children = {}

func _ready() -> void:
	for child_name in ray_names:
		var new_child = Sprite.new()
#		new_child.visible = false
		new_child.texture = tex
		new_child.name = child_name
		
		children[child_name] = new_child
		call_deferred("add_child", new_child)


func _process(delta: float) -> void:
	
	for direction in children:
		var child = children[direction]
		var pos
		if direction.length() == 1:
			pos = parent.get_pos(\
			GLOBAL.letter_to_direction[direction])
		else:
			pos = parent.get_pos2(\
			GLOBAL.letter_to_direction[direction[0]],
			GLOBAL.letter_to_direction[direction[1]])
	
		if pos:
			child.visible = true
			child.global_transform.origin = pos
		else:
			child.visible = false
