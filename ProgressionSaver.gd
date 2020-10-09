extends Node

onready var saver = $Saver

#const savefile = "user://save_progression.dat"
const savefile = "res://save_progression.save"

var default_data = {
	"levels_completed" : {}
}

var data = default_data

signal progression_data_updated()


func _ready() -> void:
	# Load progression data
	_load()


func _save() -> void:
	# Save progression data on change
	var file = File.new()
	var err = file.open(savefile, File.WRITE)
	file.store_string(var2str(data))
	
	LOG.pr(2, "data <%s>  SAVED to <%s>" % [data, savefile], "ProgressionSaver::_save")


func _load():
	# Loader
	var file = File.new()
	
	if file.file_exists(savefile):
		LOG.pr(2, "file found [%s]" % savefile, "ProgressionSaver::_load")
#		file.open(savefile, File.WRITE)
#		data = default_data.duplicate(true)
#		return
		
		var err = file.open(savefile, File.READ)
		if err != OK:
			#TODO
			assert(0)
		
		var string = file.get_as_text()
	
		var parsed = JSON.parse(string)
		if parsed.error != OK:
			assert(0)
		data = parsed.result
		
#		var parsed = str2var(string)
#		data = parsed
#
	else:
		LOG.pr(2, "file could not found [%s]" % savefile, "ProgressionSaver::_load")
		
		data = default_data.duplicate(true)
	
	LOG.pr(2, "data : <%s>" % data, "ProgressionSaver::_load")
