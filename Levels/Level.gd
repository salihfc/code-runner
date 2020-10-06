extends Node2D

var Game = null

func _ready() -> void:
#	$Finish.connect("body_entered", self, "_on_Finish_area_entered")
	pass


func _on_Finish_body_entered(body: Node) -> void:
	LOG.pr(2, "PLAYER SHOULD WIN", "Level::_on_Finish_area_entered")
	if Game:
		Game.on_player_win()
