extends Control
class_name Character

signal died

@export var data: CharacterData
signal ready_to_fight

var max_hp: int
var hp: int

@onready var inventory = $Inventory
@onready var status_manager = $StatusManager
@onready var hp_label = $Hp

var _cached_opponent : Character = null

func _ready() -> void:
	if data:
		if inventory:
			inventory.items_loaded.connect(_on_inventory_loaded)
			inventory.initialize_items(data.item_array)
			
			max_hp = data.base_hp
			hp = max_hp
			set_hp()

func set_opponent(opponent) -> void:
	_cached_opponent = opponent

func _on_inventory_loaded() -> void:
	if inventory and _cached_opponent:
		inventory.initialize_combat_logic(self, _cached_opponent)
		
	ready_to_fight.emit()

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

func stop_battle_logic() -> void:
	if inventory:
		inventory.stop_all_cooldowns()
	if status_manager:
		status_manager.clear_all_statuses()
