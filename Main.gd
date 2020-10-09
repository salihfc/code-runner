extends Node2D

onready var Game = $ViewportContainer/Viewport/Game
onready var saveTimer = $SaveTimer
onready var camera = $MainCamera
onready var analyzer = $Analyzer

var current_camera_region :int = 0

enum {
	TITLE = 0,
	LEVEL_SELECTION,
	EXTRA,
	GAME,
}

func _ready() -> void:
	GLOBAL.Main = self
	
	# stop the game
	Game.pause_mode = PAUSE_MODE_STOP
	change_camera_region(LEVEL_SELECTION)
	#
	GLOBAL.input_text_editor = $UI/TextEdit
#	_on_level_selected("1")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		
		match current_camera_region:
			TITLE, LEVEL_SELECTION:
				_on_exit()
			GAME:
				change_camera_region(LEVEL_SELECTION)
				
	if Input.is_action_just_pressed("run"):
		$Analyzer._on_Analyze_pressed()
	
	if Input.is_action_just_pressed("save_code"):
		save_code()


func _on_exit() -> void:
	get_tree().quit()


func save_code() -> void:
	SAVE.save(GLOBAL.current_level, GLOBAL.input_text_editor.text)


func change_camera_region(idx : int) -> void:
	
	if idx < 0 or idx > 3:
		LOG.err("invalid region [%s]" % idx, "Main::change_camera_region")
		assert(0)
	
	current_camera_region = idx
	camera.global_position = GLOBAL.camera_position[idx]
	

func _on_level_selected(level_name : String) -> void:
	LOG.pr(1, "Level selection recognized [%s]" % level_name, "Main::_on_level_selected")
	# Load level
	Game.load_level(level_name)
	# Change to Game Screem
	change_camera_region(GAME)


func _on_Main_tree_exiting() -> void:
	save_code()
	PROGRESSION.save()


func _on_Save_pressed() -> void:
	save_code()


func _on_Back_pressed() -> void:
	save_code()
	analyzer._on_Reset_pressed()
	change_camera_region(LEVEL_SELECTION)
