extends Control

@onready var icon = $Texture

var required_tag: String = ""

func set_active(is_active: bool) -> void:
	if is_active:
		icon.texture = "res://assets/ballFullAtlas.tres"
	else:
		icon.texture = "res://assets/ballEmptyAtlas.tres"
