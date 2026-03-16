extends Node

signal new_log_added(message: String)

func add_log(msg: String) -> void:
	new_log_added.emit(msg)
