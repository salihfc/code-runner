extends TextEdit

var keywords = {
	"JU" : Color.orange,
	"JI" : Color.orange,
	"JN" : Color.orange,
	"CALL" : Color.orange,
	"WHILE" : Color.orange,
	
	"JUMP" : Color.blueviolet,
	"MOVE" : Color.blueviolet,
	"GD_U" : Color.blueviolet,
	"GD_L" : Color.blueviolet,
	"GD_R" : Color.blueviolet,
	"GD_D" : Color.blueviolet,
	
	"U" : Color.blanchedalmond,
	"L" : Color.blanchedalmond,
	"R" : Color.blanchedalmond,
	"D" : Color.blanchedalmond,
	
}

func _ready() -> void:
	
	GLOBAL.input_text_editor = self

	for keyword in keywords:
		add_keyword_color(keyword, keywords[keyword])
