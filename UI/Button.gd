extends TextureButton

onready var feedback = $ButtonHoverFeedback

func _ready() -> void:
	feedback.visible = false;
	connect("mouse_entered", self, "_on_Button_mouse_entered");
	connect("mouse_exited", self, "_on_Button_mouse_exited");


func _on_Button_mouse_entered() -> void:
	feedback.visible = true;


func _on_Button_mouse_exited() -> void:
	feedback.visible = false;
