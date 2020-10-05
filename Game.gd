extends Node2D

onready var Player = $Player
var player_start_pos


func _ready() -> void:
	player_start_pos = Player.global_position
	get_node("Level").Game = self


func reset_player() -> void:
	Player.global_position = player_start_pos


func _on_Reset_pressed() -> void:
	reset_player()


func on_player_win() -> void:
	assert(0)
	reset_player()
