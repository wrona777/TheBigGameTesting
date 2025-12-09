extends ItemEffect

class_name EffectAttack

@export var amount : int = 10

func execute(_owner_node, target_node) -> void:
	if target_node.has_method("take_damage"):
		target_node.take_damage(amount)
