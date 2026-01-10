extends CharacterBody2D
class_name NPC

@export var npc_id: String = ""          # unique ID (farmer, fisherman, etc.)
@export var dialogue_id: String = ""     # dialogue key
@export var npc_name: String = ""
@export var idle_direction: String = "Down"

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $InteractArea

var player_in_range := false   # (non-invasive)

func _ready():
	_play_idle()

	# 🔹 NEW — proximity tracking only
	if interact_area:
		interact_area.body_entered.connect(_on_body_entered)
		interact_area.body_exited.connect(_on_body_exited)

func _play_idle():
	var anim_name := "Idle" + idle_direction
	if anim.sprite_frames.has_animation(anim_name):
		anim.play(anim_name)

#player proximity detection
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("🟢 Player entered NPC range:", npc_name)


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		print("🔴 Player left NPC range:", npc_name)

func interact() -> void:
	# 🔒 Prevent talking from far away
	if not player_in_range:
		return

	print("Talking to", npc_name)

	if dialogue_id != "":
		DialogueManager.start_dialogue(dialogue_id, self)

func _physics_process(_delta: float) -> void:
	if velocity != Vector2.ZERO:
		move_and_slide()
