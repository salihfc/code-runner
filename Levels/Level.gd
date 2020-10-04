extends Node2D

var Game = null


func _on_Finish_area_entered(area: Area2D) -> void:
	if Game:
		Game.on_player_win()
