extends RichTextLabel

onready var analyzer = get_node("../../../Analyzer")


func _ready() -> void:
	analyzer.connect("new_analysis", self, "_analysis_update")


func _analysis_update(new_text) -> void:
	text = new_text

func _print(new_text : String) -> void:
	text = text + "\n" + new_text


func _on_Clear_pressed() -> void:
	text = ""
