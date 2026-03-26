extends Node
class_name StatusManager

var active_statuses: Dictionary = {}

@onready var character = get_parent() as Character

func _process(delta: float) -> void:
	for status_name in active_statuses.keys():
		_handle_status_logic(status_name, active_statuses[status_name], delta)

func apply_status(status_name : String, stacks_to_add : int = 1) -> void:
	if active_statuses.has(status_name):
		active_statuses[status_name]["stacks"] += stacks_to_add
		print("Zwiększono stacki " + status_name + " do: " + str(active_statuses[status_name]["stacks"]))
	else:
		active_statuses[status_name] = {
			"stacks": stacks_to_add,
			"tick_timer": 0.0
		}
		print("Nałożono status: " + status_name)

func cleanse_status(status_name: String) -> void:
	if active_statuses.has(status_name):
		active_statuses.erase(status_name)
		print("Oczyszczono status: " + status_name)

func _handle_status_logic(_name: String, data: Dictionary, delta: float) -> void:
	match _name:
		"bleed":
			data["tick_timer"] += delta
			
			if data["tick_timer"] >= 1.0:
				var damage = data["stacks"]
				character.take_damage(damage, "bleed")
				
				
				data["tick_timer"] -= 1.0
			
		"burn":
			data["tick_timer"] += delta
			
			if data["tick_timer"] >= 1.5:
				character.take_damage(2)
				print("Podpalenie: -2 HP")
				data["stacks"] -= 1
				
				data["tick_timer"] -= 1.5
				if data["stacks"] <= 0:
					cleanse_status(name)
				
		"regen":
			data["tick_timer"] += delta
			
			if data["tick_timer"] >= 1.0:
				character.heal(data["stacks"])
				data["tick_timer"] -= 1.0

func clear_all_statuses() -> void:
	active_statuses.clear()
