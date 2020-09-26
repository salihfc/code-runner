extends Node

const save_filename = "user://save_game.dat"

var saved_text = ""

func _ready() -> void:
	saved_text = import_from_save()

func update_text(new_text : String) -> void:
	saved_text = new_text
	save_text()

func save_text() -> void:
	var file = File.new()
	file.open(save_filename, file.WRITE)
	file.store_string(saved_text)
	file.close()

func get_text() -> String:
	return saved_text

func import_from_save() -> String:
	var file := File.new()
	file.open(save_filename, file.READ)
	
	if file.is_open():
		var val = file.get_as_text()
		file.close()
		return val
	else:
		file.open(save_filename, file.WRITE)
		file.store_string("")
		file.close()
		return ""
