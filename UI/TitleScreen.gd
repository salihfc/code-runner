extends Control

onready var play_button = $Buttons/PlayButton

func _ready() -> void:
	
	play_button.connect("pressed", self, "_on_PlayButton_pressed")


func _on_PlayButton_pressed() -> void:
	GLOBAL.Main.change_camera_region(GLOBAL.Main.LEVEL_SELECTION)
