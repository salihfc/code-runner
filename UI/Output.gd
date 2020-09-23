extends RichTextLabel

onready var analyzer = get_node("../../../Analyzer")


func _ready() -> void:
	analyzer.connect("new_analysis", self, "_analysis_update")


func _analysis_update(new_text) -> void:
	text = new_text
