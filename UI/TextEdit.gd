extends TextEdit

var keywords = {
	"JU" : Color.orange,
	"JI" : Color.orange,
	"JN" : Color.orange,
	"CALL" : Color.orange,
	"WHILE" : Color.orange,
	"PRINT" : Color.orange,
	"PUT" : Color.orange,
	"VAR" : Color.orange,
	"CONTINUE" : Color.orange,
	
	"JUMP" : Color.darkcyan,
	"MOVE" : Color.darkcyan,
	"STOP" : Color.darkcyan,
	"THROW" : Color.darkcyan,
	
	"GD_U" : Color.blueviolet,
	"GD_UL" : Color.blueviolet,
	"GD_UR" : Color.blueviolet,
	"GD_L" : Color.blueviolet,
	"GD_LD" : Color.blueviolet,
	"GD_LU" : Color.blueviolet,
	"GD_R" : Color.blueviolet,
	"GD_RD" : Color.blueviolet,
	"GD_RU" : Color.blueviolet,
	"GD_D" : Color.blueviolet,
	"GD_DL" : Color.blueviolet,
	"GD_DR" : Color.blueviolet,
	"ON_FLOOR" : Color.blueviolet,
	
	"U" : Color.blanchedalmond,
	"L" : Color.blanchedalmond,
	"R" : Color.blanchedalmond,
	"D" : Color.blanchedalmond,
	
}

func _ready() -> void:
	GLOBAL.input_text_editor = self
	for keyword in keywords:
		add_keyword_color(keyword, keywords[keyword])
	
	text = SAVE.get_text()


func _on_Reset_pressed() -> void:
	cursor_set_line(0)
