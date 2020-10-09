extends Node

var Main
var Player
var input_text_editor : TextEdit
var current_level = 0

enum DIRECTION {
	UP = 0,
	RIGHT,
	DOWN,
	LEFT
}

var direction_name = {
	0 : "Up",
	1 : "Right",
	2 : "Down",
	3 : "Left"
}

var direction_to_letter = {
	DIRECTION.UP : "U",
	DIRECTION.RIGHT : "R",
	DIRECTION.DOWN : "D",
	DIRECTION.LEFT : "L",
}

var letter_to_direction = {
	"U" : DIRECTION.UP,
	"R" : DIRECTION.RIGHT,
	"D" : DIRECTION.DOWN,
	"L" : DIRECTION.LEFT,
}

var keywords = [
	"JU" ,
	"JI" ,
	"JN" ,
	"CALL",
	"VAR",
	"PUT",
	"CONTINUE",
	"WHILE",

	"JUMP" ,
	"MOVE" ,

	"GD_U" ,
	"GD_L" ,
	"GD_R" ,
	"GD_D" ,

	"GD_UL" ,
	"GD_LU" ,
	"GD_RD" ,
	"GD_DR" ,

	"GD_UR" ,
	"GD_LD" ,
	"GD_RU" ,
	"GD_DL" ,

	"U" ,
	"L" ,
	"R" ,
	"D" ,
	
]


var camera_position = [
	Vector2(-640, -360),
	Vector2(640, -360),
	Vector2(-640, 360),
	Vector2(640, 360),
]

var auto_save_frequency :float= 60.0


var LEVELS = {
	"1" : {
		"path":"res://Levels/Level_1.tscn",
		"prev":[],
		},
	
	"2" : {
		"path":"res://Levels/Level_2.tscn",
		"prev":["1"],
	},
	
	"3" : {
		"path":"res://Levels/Level_3.tscn",
		"prev":["2"],
	},
	
	"4" : {
		"path":"res://Levels/Level_4.tscn",
		"prev":["3"],
	},
}


func reset_game() -> void:
	
	var nodes = get_tree().get_nodes_in_group("should_reset")
	for node in nodes:
		node.call_deferred("reset")
