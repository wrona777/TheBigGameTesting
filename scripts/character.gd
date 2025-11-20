extends Control
class_name Character

signal died

@export var data: CharacterData

var max_hp: int
var hp: int

@onready var inventory = $Inventory
@onready var hp_label = $Hp

func _ready() -> void:
	if data:
		if inventory:
			inventory.load_items_from_data(data.item_array)
			max_hp = data.base_hp
			hp = max_hp
			set_hp()

func set_opponent(opponent) -> void:
	if inventory:
		inventory.set_owner_and_target(self,opponent)

func take_damage(amount: int) -> void:
	hp = max(hp - amount, 0)
	set_hp()
	if hp <= 0:
		emit_signal("died")

func heal(amount : int) -> void:
	hp = min(hp + amount, max_hp)
	set_hp()

func set_hp() -> void:
	hp_label.text = "Hp: " + str(hp) + "/" + str(max_hp)
