extends Control

@onready var player : Character = $MarginContainer/HBoxContainer/Player
@onready var opponent : Character = $MarginContainer/HBoxContainer/Opponnet

func _ready() -> void:
	player.inventory.interactive = false
	opponent.inventory.interactive = false
	
	player.set_opponent(opponent)
	opponent.set_opponent(player)
	
	player.died.connect(_on_player_died)
	opponent.died.connect(_on_opponent_died)

func _on_player_died() -> void:
	print("Przegrałeś")
	_stop_all_items()

func _on_opponent_died() -> void:
	print("Wygrałeś")
	_stop_all_items()

func _stop_all_items() -> void:
	player.inventory.stop_all_cooldowns()
	opponent.inventory.stop_all_cooldowns()
