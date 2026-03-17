extends Control

@onready var main_hp_bar = $HpBar
@onready var damage_bar = $DamageBar

# Ustawiamy setter, dzięki czemu każda zmiana zmiennej 'health' 
# automatycznie odpali funkcję '_set_health'
var health : float = 100.0 : set = _set_health
var max_health : float = 100.0

func _ready():
	main_hp_bar.max_value = max_health
	damage_bar.max_value = max_health
	main_hp_bar.value = health
	damage_bar.value = health

func _set_health(new_value: float):
	var previous_health = health
	health = clamp(new_value, 0.0, max_health) 
	
	main_hp_bar.value = health
	
	if health < previous_health:
		var tween = create_tween()
		tween.tween_interval(0.1) 

		tween.tween_property(damage_bar, "value", health, 0.4)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
			
	else:
		damage_bar.value = health

func _input(event):
	if event.is_action_pressed("RightMouseClick"): 
		health -= 15.0
