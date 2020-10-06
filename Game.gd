extends Node2D

onready var Player = $Player
var player_start_pos

func load_level(level_name: String) -> void:
	
	if not GLOBAL.LEVELS.has(level_name):
		LOG.err("could not found the level [%s]" % level_name, "Game::load_level")
		assert(0)
	
	GLOBAL.current_level = level_name
	GLOBAL.input_text_editor.load_level_code()
	
	var new_level = load(GLOBAL.LEVELS[level_name]).instance()
	new_level.Game = self
	
	player_start_pos = new_level.get_node("StartPosition").global_position
	Player.global_position = player_start_pos
	
	$LevelParent.add_child(new_level)


func reset_level() -> void:
	# TODO
	reset_player()


func reset_player() -> void:
	Player.global_position = player_start_pos


func _on_Reset_pressed() -> void:
	reset_player()


func on_player_win() -> void:
	GLOBAL.Main._on_Back_pressed()
	reset_level()
