extends Control

var button

signal selected_level(level_name)

export(Texture) var completed_texture_normal
export(Texture) var completed_texture_hover

export(Texture) var uncompleted_texture_normal
export(Texture) var uncompleted_texture_hover

export(Texture) var locked_texture_normal
export(Texture) var locked_texture_hover

func init(level_name: String) -> void:
	
	LOG.pr(1, "Button created with name [%s]" % level_name, "LevelButton::init")
	
	button = $TextureButton
	$TextureButton/ButtonName.text = level_name
	
	update_button()


func update_button():
	var level_name = $TextureButton/ButtonName.text

	# defaults
	button.disabled = false

	# config according to Progression
	if PROGRESSION.is_level_completed(level_name):
		# Completed Playable
		button.texture_normal = completed_texture_normal
		button.texture_hover = completed_texture_hover
		pass
	else:
		if PROGRESSION.is_level_playable(level_name):
			# Uncompleted Playable
			button.texture_normal = uncompleted_texture_normal
			button.texture_hover = uncompleted_texture_hover
		else:
			# Locked Unplayable
#			LOG.pr(1, "Button Locked [%s]" % self.name, "LevelButton::update_button")
			button.disabled = true
			button.texture_normal = locked_texture_normal
			button.texture_hover = locked_texture_hover


func _on_TextureButton_pressed() -> void:
	LOG.pr(1, "Button pressed [%s]" % self, "LevelButton::_on_TextureButton_pressed")
	emit_signal("selected_level", $TextureButton/ButtonName.text)
