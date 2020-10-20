extends Node2D

onready var Player = $Player
var player_start_pos

signal level_completed(level_name)

func _ready() -> void:
	add_to_group("should_reset")
	
	connect("level_completed", PROGRESSION, "_on_level_completed")


func load_level(level_name: String) -> void:
	
	if not GLOBAL.LEVELS.has(level_name):
		LOG.err("could not found the level [%s]" % level_name,\
		"Game::load_level")
		assert(0)
	
	GLOBAL.current_level = level_name
	GLOBAL.input_text_editor.load_level_code()
	
	var new_level = load(GLOBAL.LEVELS[level_name]["path"]).instance()
	new_level.Game = self
	
	$LevelParent.add_child(new_level)
	
	player_start_pos = new_level.get_node("StartPosition").global_position
	Player.global_position = player_start_pos
	

func clear() -> void:
	# Delete any level require loading of the new level
	var loaded = $LevelParent.get_children()
	
	for level in loaded:
		level.queue_free()


func reset() -> void:
	LOG.pr(2, "Game RESET", "Game::reset")
	reset_player_position()


func reset_player_position() -> void:
	Player.global_position = player_start_pos


func _on_Reset_pressed() -> void:
	reset()


func on_player_win() -> void:
	emit_signal("level_completed", GLOBAL.current_level)
	
	GLOBAL.Main._on_Back_pressed()
	GLOBAL.reset_game() # clean-up of the won scene
	
#	$LevelParent.get_child()
