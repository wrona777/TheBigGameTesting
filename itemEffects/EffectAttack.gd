extends ItemEffect

class_name EffectAttack

@export var amount : int = 10

func execute(owner_node, target_node) -> void:
	if owner_node.has_method("take_damage"):
		owner_node.take_damage(amount)
