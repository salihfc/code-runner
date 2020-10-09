extends Node

func write(_filename, content) -> void:
	var file = File.new()
	var err = file.open(_filename, file.WRITE)
	
	if err != OK:
		# TODO: error handling
		assert(0)

	file.store_string(content)
	file.close()


func _load(_filename : String) -> String:
	var file := File.new()
	
	
	if file.file_exists(_filename):
		var err = file.open(_filename, file.READ)

		if err != OK:
			# TODO: error handling
			assert(0)

		var val = file.get_as_text()
		file.close()
		return val
	else:
		var err = file.open(_filename, file.WRITE)
		
		if err != OK:
			# TODO: error handling
			assert(0)		
		
		file.store_string("")
		file.close()
		return ""
