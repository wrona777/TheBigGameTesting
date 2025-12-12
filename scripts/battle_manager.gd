extends Control

@onready var player : Character = $MarginContainer/HBoxContainer/Player
@onready var opponent : Character = $MarginContainer/HBoxContainer/Opponnet

var ready_counter: int = 0

func _ready() -> void:
	player.inventory.interactive = false
	opponent.inventory.interactive = false
	
	#sygnały
	player.ready_to_fight.connect(_on_character_ready)
	opponent.ready_to_fight.connect(_on_character_ready)
	
	player.died.connect(_on_player_died)
	opponent.died.connect(_on_opponent_died)
	
	player.set_opponent(opponent)
	opponent.set_opponent(player)

func _on_character_ready() -> void:
	ready_counter += 1
	
	if ready_counter >= 2:
		start_battle()

func start_battle() -> void:
	player.inventory.start_all_cooldowns()
	opponent.inventory.start_all_cooldowns()

func _on_player_died() -> void:
	print("Przegrałeś")
	_stop_all_items()

func _on_opponent_died() -> void:
	print("Wygrałeś")
	_stop_all_items()

func _stop_all_items() -> void:
	player.stop_battle_logic()
	opponent.stop_battle_logic()
