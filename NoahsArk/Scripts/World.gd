extends Node2D
class_name World

@onready var player := $Player
@onready var camera := $Player/Camera2D
@onready var area_container := $CurrentArea

func load_area(area_scene: PackedScene, spawn_marker_name: String) -> void:
	# Remove current area
	for child in area_container.get_children():
		child.queue_free()

	# Instance new area
	var area = area_scene.instantiate()
	area_container.add_child(area)

	# Find spawn marker
	var spawn_marker := area.get_node_or_null(spawn_marker_name)
	if spawn_marker and spawn_marker is Marker2D:
		player.global_position = spawn_marker.global_position
	else:
		push_warning("Spawn marker not found: " + spawn_marker_name)

	# Apply camera bounds
	var bounds := area.get_node_or_null("CameraBounds")
	if bounds and bounds is CameraBounds:
		bounds.apply_to_camera(camera)
