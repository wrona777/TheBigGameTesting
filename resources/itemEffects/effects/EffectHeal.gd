extends ItemEffect

class_name EffectHeal

@export var amount : int = 20

func execute(owner_node, _target_node) -> void:
	if owner_node.has_method("heal"):
		owner_node.heal(amount)
