extends Node

var active_dialogue: DialogueData
var line_index := 0
var active_npc: Node

func _get_ui() -> CanvasLayer:
	return get_node("/root/DialogueUI") as CanvasLayer

func start_dialogue(dialogue_id: String, npc: Node) -> void:
	print("UI children:", _get_ui().get_children())
	print("UI node:", _get_ui())
	var db := get_tree().get_first_node_in_group("dialogue_database") as DialogueDatabase
	if db == null:
		push_error("DialogueDatabase missing")
		return

	active_dialogue = db.get_dialogue(dialogue_id)
	if active_dialogue == null:
		push_error("Unknown dialogue: " + dialogue_id)
		return

	active_npc = npc
	line_index = 0

	var ui = _get_ui()
	ui.show_line(active_dialogue.lines[line_index], npc.npc_name)

func next_line() -> void:
	if active_dialogue == null:
		return

	line_index += 1
	if line_index >= active_dialogue.lines.size():
		end_dialogue()
		return

	_get_ui().show_line(active_dialogue.lines[line_index], active_npc.npc_name)

func end_dialogue() -> void:
	active_dialogue = null
	active_npc = null
	_get_ui().hide_dialogue()
