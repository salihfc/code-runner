extends Node2D

onready var Game = $ViewportContainer/Viewport/Game
onready var textEdit = $UI/TextEdit
onready var saveTimer = $SaveTimer
onready var camera = $MainCamera
onready var analyzer = $Analyzer

enum {
	TITLE = 0,
	LEVEL_SELECTION,
	EXTRA,
	GAME,
}

func _ready() -> void:
	# stop the game
	Game.pause_mode = PAUSE_MODE_STOP
	change_camera_region(LEVEL_SELECTION)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		_on_exit()
	
	if Input.is_action_just_pressed("run"):
		$Analyzer._on_Analyze_pressed()
	
	if Input.is_action_just_pressed("save_code"):
		save_code()


func _on_exit() -> void:
	get_tree().quit()


func save_code() -> void:
	SAVE.save(GLOBAL.current_level, textEdit.text)


func change_camera_region(idx : int) -> void:
	
	if idx < 0 or idx > 3:
		LOG.err("invalid region [%s]" % idx, "Main::change_camera_region")
		assert(0)
	
	camera.global_position = GLOBAL.camera_position[idx]
	

func _on_level_selected(level_name : String) -> void:
	LOG.pr(1, "Level selection recognized [%s]" % level_name, "Main::_on_level_selected")
	# Set up variables and load saved code
	GLOBAL.current_level = level_name
	textEdit.load_level_code()
	# Load level
	
	# Change to Game Screem
	change_camera_region(GAME)


func _on_Main_tree_exiting() -> void:
	save_code()


func _on_Save_pressed() -> void:
	save_code()


func _on_Back_pressed() -> void:
	save_code()
	analyzer._on_Reset_pressed()
	change_camera_region(LEVEL_SELECTION)
