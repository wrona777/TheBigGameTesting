extends Control

@onready var icon = $Texture

var required_tags: Array[String] = []

func set_active(is_active: bool) -> void:
	if is_active:
		icon.texture = "res://assets/ballFullAtlas.tres"
	else:
		icon.texture = "res://assets/ballEmptyAtlas.tres"

func check_item(neighbor_item_resource: Item) -> bool:
	if neighbor_item_resource == null: return false
	
	for tag in required_tags:
		if neighbor_item_resource.my_tags.has(tag):
			return true
			
	return false
