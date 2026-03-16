extends ItemEffect

class_name EffectAttack

@export var amount : int = 10

func execute(_owner_node, target_node, item_name) -> void:
	if target_node.has_method("take_damage"):
		target_node.take_damage(amount)
		BattleLoggerAutoLoad.add_log("[color=red] Zadano %s %s za pomocą %s[/color]" % [amount, target_node.data.character_name, item_name])
