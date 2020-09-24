extends Node

var Player
var input_text_editor : TextEdit

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

var letter_to_direction = {
	"U" : DIRECTION.UP,
	"L" : DIRECTION.LEFT,
	"D" : DIRECTION.DOWN,
	"R" : DIRECTION.RIGHT,
}

var keywords = [
	"JU" ,
	"JI" ,
	"JN" ,
	"JUMP" ,
	"MOVE" ,
	"GD_U" ,
	"GD_L" ,
	"GD_R" ,
	"GD_D" ,
	
	"U" ,
	"L" ,
	"R" ,
	"D" ,
	
	"CALL",
]
