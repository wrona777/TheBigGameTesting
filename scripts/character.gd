extends Node
class_name Character

@export var data: CharacterData
var max_hp: int
var hp: int

@onready var inventory = $Inventory

func _ready() -> void:
	if data:
		if inventory:
			inventory.load_items_from_data(data.item_array)

func set_opponent() -> void:
	if inventory:
		inventory.set_owner_and_target(self)
