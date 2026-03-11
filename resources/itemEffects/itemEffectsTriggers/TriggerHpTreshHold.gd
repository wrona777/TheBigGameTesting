extends ItemTrigger
class_name TriggerHpThreshold

enum CompareType { LESS_THAN, GREATER_THAN }

@export var threshold_percent: float = 0.5
@export var compare_type: CompareType = CompareType.LESS_THAN
@export var target_self: bool = true

func is_condition_met(user: Character, target: Character) -> bool:
	var entity_to_check = user if target_self else target
	
	if entity_to_check == null:
		return false
		
	if entity_to_check.max_hp == 0: return false
	var current_percent = float(entity_to_check.hp) / float(entity_to_check.max_hp)
	
	if compare_type == CompareType.LESS_THAN:
		return current_percent < threshold_percent
	else:
		return current_percent > threshold_percent
