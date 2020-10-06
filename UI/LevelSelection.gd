extends Control

const button_prefab = preload("res://UI/LevelButton.tscn")
onready var main = get_parent()
onready var grid = $UI/GridPanel/GridContainer

#NOTE: temporary_static_data
var button_data = [
	"1",
	"2",
	"3",
]

func _ready() -> void:
	create_buttons()

func activate() -> void:
	#
	pass

func create_buttons() -> void:
	# get_level data and construct level buttons from it

	for button_name in button_data:
		var new_button = button_prefab.instance()
		new_button.init(button_name)
		new_button.connect("selected_level", main, "_on_level_selected")
		grid.add_child(new_button)
