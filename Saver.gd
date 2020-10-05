extends Node

func write(_filename, content) -> void:
	var file = File.new()
	file.open(_filename, file.WRITE)
	file.store_string(content)
	file.close()


func _load(_filename : String) -> String:
	var file := File.new()
	file.open(_filename, file.READ)
	
	if file.is_open():
		var val = file.get_as_text()
		file.close()
		return val
	else:
		file.open(_filename, file.WRITE)
		file.store_string("")
		file.close()
		return ""
