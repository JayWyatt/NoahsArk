extends CanvasLayer

@onready var name_label: Label = $Panel/VBoxContainer/NameLabel
@onready var dialogue_label: RichTextLabel = $Panel/VBoxContainer/DialogueLabel
@onready var continue_hint: Label = $Panel/VBoxContainer/ContinueHint

func _ready():
	visible = false
	set_process_input(true)

func show_line(text: String, speaker_name := "") -> void:
	visible = true
	name_label.text = speaker_name
	dialogue_label.text = text

func hide_dialogue() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if DialogueManager.active_dialogue == null:
		return

	if event.is_action_pressed("interact"):
		DialogueManager.next_line()
