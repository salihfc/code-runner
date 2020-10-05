extends Control

signal selected_level(level_name)

func init(button_label: String) -> void:
	LOG.pr(1, "Button created with name [%s]" % button_label, "LevelButton::init")
	$TextureButton/ButtonName.text = button_label
	


func _on_TextureButton_pressed() -> void:
	LOG.pr(1, "Button pressed [%s]" % self, "LevelButton::_on_TextureButton_pressed")
	emit_signal("selected_level", $TextureButton/ButtonName.text)
