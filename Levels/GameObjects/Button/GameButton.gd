extends Node2D

export(Color) var group_color = Color.white
export(String) var group

func _ready() -> void:
	$Sprite.modulate = group_color


func _on_Area2D_body_entered(body: Node) -> void:
	var nodes = get_tree().get_nodes_in_group(group)
	for node in nodes:
		node.dissipate()
