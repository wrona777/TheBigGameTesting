extends ItemEffect

class_name EffectHeal

@export var amount : int = 20

func execute(owner_node, _target_node, item_name) -> void:
	if owner_node.has_method("heal"):
		owner_node.heal(amount)
		BattleLoggerAutoLoad.add_log("[color=green] Wyleczono %s %s za pomocą %s[/color]" % [amount, owner_node.data.character_name, item_name])
