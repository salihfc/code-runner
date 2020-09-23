extends TextEdit

var keywords = {
	"JU" : Color.orange,
	"JI" : Color.orange,
	"JN" : Color.orange,
	"JUMP" : Color.orange,
	"MOVE" : Color.orange,
	"GDU" : Color.orange,
	"GDL" : Color.orange,
	"GDR" : Color.orange,
	"GDD" : Color.orange,
	
	"U" : Color.blanchedalmond,
	"L" : Color.blanchedalmond,
	"R" : Color.blanchedalmond,
	"D" : Color.blanchedalmond,
	
	"CALL" : Color.greenyellow,
}

func _ready() -> void:

	for keyword in keywords:
		add_keyword_color(keyword, keywords[keyword])
