extends Area2D

@export var target_area: PackedScene
@export var target_spawn_marker: String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var world := get_tree().get_first_node_in_group("world")
		if world:
			world.load_area(target_area, target_spawn_marker)
