extends Node

onready var saver = $Saver

const savefile = "user://save_progression.dat"

var default_data = {
	"levels_completed" : {}
}

var progression_data


func _ready() -> void:
	# Load progression data
	_load()


func update(key, data) -> void:
	# update progression and save
	progression_data[key] = data
	_save()


func _save() -> void:
	# Save progression data on change
	var file = File.new()
	var err = file.open(savefile, File.WRITE)
	file.store_string(String(progression_data))


func _load():
	# Loader
	var file = File.new()
	
	if file.file_exists(savefile):
		var err = file.open(savefile, File.READ)
		
		if err != OK:
			#TODO
			assert(0)
		
		var string = file.get_as_text()
		var parsed = JSON.parse(string)
		
		if parsed.error != OK:
			assert(0)
		
		progression_data = parsed.result
	
	else:
		progression_data = default_data.duplicate(true)
