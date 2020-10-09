extends Node

onready var saver = $ProgressionSaver


func is_level_completed(level_name) -> bool:
	return saver.progression_data["levels_completed"].has(level_name)


func _on_level_completed(level_name) -> void:
	LOG.pr(2, "level completed [%s] ACK" % level_name, "PROGRESSION::_on_level_completed")
	
	saver.progression_data["levels_completed"][level_name] = ""
