extends Node2D

var Game = null

func _ready() -> void:
#	$Finish.connect("body_entered", self, "_on_Finish_area_entered")
	pass


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Debug_W"):
		LOG.pr(2, "DEBUG_W Received", "Level::Process")
		$StaticTilemap1.set_cell(10, 10, 2)


func _on_Finish_body_entered(body: Node) -> void:
	LOG.pr(2, "PLAYER SHOULD WIN", "Level::_on_Finish_area_entered")
	if Game:
		Game.on_player_win()
