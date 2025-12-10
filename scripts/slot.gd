extends Control
class_name Slot

@onready var icon: TextureRect    = $TextureRect
@onready var hover_rect: ColorRect = $ColorRect

signal slot_entered(slot)
signal slot_exited(slot)

var is_hovering := false

var slot_ID : int
var item_stored = null

func _ready() -> void:
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	custom_minimum_size = Vector2(App.cell_size, App.cell_size)

func _process(_delta: float) -> void:
	if get_global_rect().has_point(get_global_mouse_position()):
		if not is_hovering:
			is_hovering = true
			emit_signal("slot_entered", self)
	else:
		if is_hovering:
			is_hovering = false
			emit_signal("slot_exited", self)

func set_color(color_type: String) -> void:
	if color_type == "Free":
		hover_rect.color = Color(0.2, 1.0, 0.2, 0.25)
	elif color_type == "Taken":
		hover_rect.color = Color(1.0, 0.2, 0.2, 0.25)
	elif color_type == "Null":
		hover_rect.color = Color(0, 0, 0, 0)
