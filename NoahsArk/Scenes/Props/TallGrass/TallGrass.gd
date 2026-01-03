extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Area2D
@onready var grass_sprite: Sprite2D = $Sprite2D
@onready var overlay: Sprite2D = $Sprite2D2


const GRASS_OVERLAY_TEXTURE := preload(
	"res://Assets/TileSets/Home Made Assets/Exported/steppedgrass.png"
)

func _ready() -> void:
		overlay.visible = false
		grass_sprite.visible = true

func _on_area_2d_area_entered(area_entered: Area2D) -> void:
	if area_entered.name != "GrassDetector":
		return

#Entering Grass
	grass_sprite.visible = false
	overlay.visible = true
	anim_player.play("Stepped", 0.0)


func _on_area_2d_area_exited(area_exited: Area2D) -> void:
	if area_exited.name != "GrassDetector":
		return

	anim_player.stop()
	grass_sprite.visible = true
	overlay.visible = false

func _on_stepped_finished() -> void:
	# Only blend if the player is still in the grass
	if not overlay.visible:
		return

	overlay.visible = true
	grass_sprite.visible = true
	anim_player.play("Idle", 0.15)
