extends Resource
class_name CharacterData

@export var name : String = "Null"

#stats
@export var base_hp : int = 100

#items
@export var item_array : Array = [
	{
		"item_path" : preload("res://scripts/Resource/items/Apple.tres"),
		"slot" : 8,
		"rotation_deg": 1
	},
	{
		"item_path" : preload("res://scripts/Resource/items/Sword.tres"),
		"slot" : 30,
		"rotation_deg": 2
	},
	{
		"item_path" : preload("res://scripts/Resource/items/Sword.tres"),
		"slot" : 50,
		"rotation_deg": 3
	}
]
