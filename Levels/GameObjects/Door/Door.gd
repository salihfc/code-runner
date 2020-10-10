extends Node2D

export(Color) var group_color = Color.white
export(String) var group


func _ready() -> void:
	add_to_group(group)
	$Sprite.modulate = group_color


func dissipate() -> void:
	$AnimationPlayer.play("Dissipate")
