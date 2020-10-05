extends Node

onready var saver = $Saver
onready var timer = $AutoSaveTimer

const savefile_format = "user://save_%s.dat"

var last_saved_name := ""
var last_saved_code := ""


func _ready() -> void:
	timer.wait_time = GLOBAL.auto_save_frequency
	timer.start()


func save(_name, code :String) -> void:
	last_saved_code = code
	last_saved_name = String(_name)
	_auto_save()


func _load(_name :String) -> String:
	return saver._load(savefile_format % _name)


func _auto_save() -> void:
	saver.write(savefile_format % last_saved_name, last_saved_code)


func _on_AutoSaveTimer_timeout() -> void:
	_auto_save()
	timer.start()
