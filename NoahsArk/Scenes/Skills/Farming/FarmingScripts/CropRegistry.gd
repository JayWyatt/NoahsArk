extends Node
class_name CropRegistry

@export var crop_visual_scene: PackedScene
@export var crop_items: Dictionary = {}


# Key: "tilemap_path|x,y"
# Value: Dictionary with full crop data
var planted_crops: Dictionary = {}

# ===============================
# INTERNAL HELPERS
# ===============================
func _make_key(tilemap: TileMapLayer, cell: Vector2i) -> String:
	return "%s|%s,%s" % [
		tilemap.get_path(),
		cell.x,
		cell.y
	]

# ===============================
# PLANTING
# ===============================
func plant_seed(
	area: Node2D,
	tilemap: TileMapLayer,
	cell: Vector2i,
	seed_crop_id: String
) -> bool:
	var key := _make_key(tilemap, cell)

	if planted_crops.has(key):
		return false # already planted

	# 🔴 STORE COMPLETE DATA (CRITICAL FIX)
	planted_crops[key] = {
		"crop_id": seed_crop_id,
		"planted_time": Time.get_unix_time_from_system(),
		"area_path": area.scene_file_path,
		"tilemap_path": tilemap.get_path(),
		"cell": cell
	}

	print("🌱 Seed planted:", planted_crops[key])
	return true

# ===============================
# AREA VISUAL SPAWNING
# ===============================
func spawn_crops_for_area(area: Node2D) -> void:
	print("🟢 spawn_crops_for_area CALLED for:", area.name)
	print("🌾 planted_crops keys:", planted_crops.keys())

	for key in planted_crops.keys():
		var data = planted_crops[key]

		# 🛡️ SAFETY GUARD (PREVENTS CRASHES)
		if not data.has("area_path"):
			print("⚠️ Skipping invalid crop data:", data)
			continue

		print("🔎 checking crop data:", data)
		print("🔎 area_path =", data["area_path"])
		print("🔎 current area =", area.scene_file_path)

		if data["area_path"] != area.scene_file_path:
			print("⏭️ skipping crop (different area)")
			continue

		print("🧩 trying tilemap path:", data["tilemap_path"])
		var tilemap := area.get_node_or_null(data["tilemap_path"]) as TileMapLayer

		if tilemap == null:
			print("❌ tilemap NOT FOUND")
			continue

		print("🌱 INSTANTIATING CropVisual")

		# Use exported scene if assigned, otherwise fallback
		var crop_scene: PackedScene = crop_visual_scene
		if crop_scene == null:
			crop_scene = preload(
				"res://Scenes/Skills/Farming/FarmingScenes/CropVisual.tscn"
			)

		var crop := crop_scene.instantiate() as CropVisual
		area.add_child(crop)

		crop.setup(
			data["crop_id"],
			data["planted_time"],
			tilemap,
			data["cell"]
		)

# ===============================
# PROCESS (NOT USED YET)
# ===============================
func _process(_delta: float) -> void:
	pass

func spawn_single_crop_visual(
	area: Node2D,
	tilemap: TileMapLayer,
	cell: Vector2i,
	data: Dictionary,
) -> void:
	if crop_visual_scene == null:
		push_error("❌ Crop visual scene not assigned")
		return

	var crop := crop_visual_scene.instantiate() as CropVisual
	area.add_child(crop)

	crop.setup(
		data["crop_id"],
		data["planted_time"],
		tilemap,
		cell
	)
