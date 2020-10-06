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
	var err = file.open(_filename, file.READ)
	
	if err != OK:
		# TODO: error handling
		assert(0)
	
	if file.is_open():
		var val = file.get_as_text()
		file.close()
		return val
	else:
		file.close()
		err = file.open(_filename, file.WRITE)
		
		if err != OK:
			# TODO: error handling
			assert(0)		
		
		file.store_string("")
		file.close()
		return ""
