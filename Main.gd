extends Node2D

onready var Game = $ViewportContainer/Viewport/Game

func _ready() -> void:
	get_tree().paused = true
	Game.pause_mode = PAUSE_MODE_STOP

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("exit"):
		_on_exit()
	
	if Input.is_action_just_pressed("run"):
		$Analyzer._on_Analyze_pressed()


func _on_exit() -> void:
	
	get_tree().quit()
