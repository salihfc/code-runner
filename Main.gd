extends Node2D

onready var Game = $ViewportContainer/Viewport/Game
onready var textEdit = $UI/TextEdit
onready var saveTimer = $SaveTimer

func _ready() -> void:
	get_tree().paused = true
	Game.pause_mode = PAUSE_MODE_STOP
	


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		_on_exit()
	
	if Input.is_action_just_pressed("run"):
		$Analyzer._on_Analyze_pressed()
	
	if Input.is_action_just_pressed("save_code"):
		save_text_edit()

func _on_exit() -> void:
	get_tree().quit()


func save_text_edit() -> void:
	SAVE.update_text(textEdit.text)
	SAVE.save_text()


func _on_SaveTimer_timeout() -> void:
	save_text_edit()
	saveTimer.start(60)


func _on_Main_tree_exiting() -> void:
	save_text_edit()


func _on_Save_pressed() -> void:
	save_text_edit()
