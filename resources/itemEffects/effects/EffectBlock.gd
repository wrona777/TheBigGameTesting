extends ItemEffect

class_name EffectBlock

@export var block_chance: int = 15
@export var block_amount: int = 5

func execute_block(incoming_damage: int) -> int:
	if randi_range(1, 100) <= block_chance:
		
		var new_damage = max(0, incoming_damage - block_amount)
		var blocked_amount = incoming_damage - new_damage
		
		#Logi
		if new_damage == 0:
			BattleLoggerAutoLoad.add_log("[color=cyan]Blok: Całkowicie zanegowano atak![/color]")
		else:
			BattleLoggerAutoLoad.add_log("[color=cyan]Blok: Zredukowano obrażenia o %s![/color]" % blocked_amount)
			
		return new_damage #Dmg po redukcji
		
	return incoming_damage #Pełne obrażenia
