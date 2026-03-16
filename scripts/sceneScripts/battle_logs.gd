extends Control

@onready var log_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	BattleLoggerAutoLoad.new_log_added.connect(_on_new_log)
	log_label.text = "[color=yellow]--- Walka Rozpoczęta ---[/color]\n"

func _on_new_log(message: String) -> void:
	log_label.append_text(message + "\n")
