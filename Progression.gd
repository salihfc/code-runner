extends Node

onready var saver = $ProgressionSaver


func is_level_playable(level_name) -> bool:
	var level = GLOBAL.LEVELS[level_name]
	var prevs = level["prev"]
	
	for pre in prevs:
		if not is_level_completed(pre):
			return false
	
	return true


func is_level_completed(level_name) -> bool:
#	LOG.pr(2, "data:[%s]" % saver.data, "PROGRESSION::is_level_completed")
	return saver.data["levels_completed"].has(level_name)


func save() -> void:
	saver._save()


func _on_level_completed(level_name) -> void:
	LOG.pr(2, "level completed [%s] ACK" % level_name, "PROGRESSION::_on_level_completed")
	
	saver.data["levels_completed"][level_name] = "true"
	saver._save()
	
	# Update UI
	var buttons = get_tree().get_nodes_in_group("level_buttons")
	for button in buttons:
		button.update_button()
