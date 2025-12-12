extends ItemEffect

class_name EffectApplyStatus

@export var status_name: String = "bleed"
@export var stacks: int = 1

func execute(_user: Node, target: Node) -> void:
	if target.has_node("StatusManager"):
		var target_status_manager = target.get_node("StatusManager")
		target_status_manager.apply_status(status_name, stacks)
	else:
		print("Cel nie ma StatusManagera!")
