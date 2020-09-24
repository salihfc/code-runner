extends TextEdit

var keywords = {
	"JU" : Color.orange,
	"JI" : Color.orange,
	"JN" : Color.orange,
	"JUMP" : Color.orange,
	"MOVE" : Color.orange,
	"GD_U" : Color.orange,
	"GD_L" : Color.orange,
	"GD_R" : Color.orange,
	"GD_D" : Color.orange,
	
	"U" : Color.blanchedalmond,
	"L" : Color.blanchedalmond,
	"R" : Color.blanchedalmond,
	"D" : Color.blanchedalmond,
	
	"CALL" : Color.greenyellow,
}

func _ready() -> void:
	
	GLOBAL.input_text_editor = self

	for keyword in keywords:
		add_keyword_color(keyword, keywords[keyword])
