extends Control
@export var item : Item

@onready var item_icon = $TextureRect
@onready var cooldown_timer = $CooldownTimer
@onready var charges_label = $ChargesLabel

var shader_mat: ShaderMaterial

var selected = false
var item_grids := []
var grid_anchor = null
var synergy_markers: Array = []

var a_owner = null
var a_target = null
var inventory_ref: Inventory = null

var current_charges: int = 0

func _ready() -> void:
	if item:
		item_setter()

func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	
	if item.trigger == null:
		_bar_progress()
	else:
		if cooldown_timer.is_stopped() and (current_charges > 0 or item.max_charges == 0):
			_check_trigger()
	
	_check_synergies()

#Item/Grid Stuff
func item_setter() -> void:
	item_icon.size = Vector2(item.size) * App.cell_size
	item_icon.texture = item.icon
	current_charges = item.max_charges
	
	_spawn_synergy_markers()
	set_item_grids()
	_update_charges_visual()
	
	shader_mat = item_icon.material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("progress", 0.0)
		shader_mat.set_shader_parameter("fill_min_y", item.fill_min_y)
		shader_mat.set_shader_parameter("fill_max_y", item.fill_max_y)
		shader_mat.set_shader_parameter("fill_strength", item.fill_strength)

func set_item_grids() -> void:
	var temp_grid_array = []
	for point in item.grids.split("/"):
		temp_grid_array.push_back(point.split(","))
	
	for grid in temp_grid_array:
		var converter_array = []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)

func rotate():
	for grid in item_grids:
		var temp_y = grid[0]
		grid[0] = -grid[1]
		grid[1] = temp_y
	print(item_grids)
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0

func _snap_item_to_inventory(destination : Vector2) -> void:
	var tween = get_tree().create_tween()
	
	var offset : Vector2 = item.additional_offset_array[item.item_offset_type][int(rotation_degrees / 90)] * App.cell_size
	
	destination = destination + offset
	tween.tween_property(self, "global_position", destination, 0.15).set_trans(Tween.TRANS_SINE)
	selected = false


#THE PROGRESS/TIMER SECTION
func _start_cooldown() -> void:
	if item == null or shader_mat == null or item.trigger != null:
		return

	cooldown_timer.wait_time = item.base_cooldown
	cooldown_timer.start()
	shader_mat.set_shader_parameter("progress", 0.0)

func _stop_cooldown() -> void:
	if cooldown_timer:
		cooldown_timer.stop()
	
	shader_mat.set_shader_parameter("progress", 0.0)

func _on_cooldown_timer_timeout() -> void:
	if item.trigger != null:
		return
	_use_item_effect()

func _use_item_effect() -> void:
	if item == null:
		return
	
	for effect in item.effects:
		effect.execute(a_owner, a_target)

func _bar_progress():
	if shader_mat == null or cooldown_timer.is_stopped():
		return
		
	var total = cooldown_timer.wait_time
	var left = cooldown_timer.time_left
	var progress = 1.0 - (left / total)
	
	shader_mat.set_shader_parameter("progress", clampf(progress, 0.0, 1.0))

#Markery

func _spawn_synergy_markers() -> void:
	if item.synergy_input_tags.is_empty():
		return

	for pos in item.synergy_points:
		var marker = preload("res://scenes/synergy_marker.tscn").instantiate()
		add_child(marker)
		
		@warning_ignore("integer_division")
		marker.position = pos * App.cell_size
		marker.required_tags = item.synergy_input_tags
		
		synergy_markers.append(marker)

func _check_synergies() -> void:
	if inventory_ref == null: return
	
	for marker in synergy_markers:
		var marker_global_pos = marker.icon.global_position 
		
		var found_node = inventory_ref.get_item_at_global_pos(marker_global_pos)
		
		var match_found = false
		
		if found_node and found_node != self:
			if marker.check_resource(found_node.item):
				match_found = true
				# TU MOŻESZ DODAĆ LOGIKĘ BUFFOWANIA (np. zliczanie aktywnych synergii)
		marker.set_visual_state(match_found)

#Inne

func _check_trigger() -> void:
	if item.trigger and a_owner:
		if item.trigger.is_condition_met(a_owner, a_target):
			_use_item_effect()
			
			cooldown_timer.start() 
			
			if item.max_charges > 0:
				current_charges -= 1
				_update_charges_visual()

func _update_charges_visual() -> void:
	if charges_label == null: return
	
	if item.max_charges <= 0:
		charges_label.visible = false
		return
	
	charges_label.visible = true
	charges_label.text = str(current_charges)
	
	if current_charges <= 0:
		charges_label.visible = false 
		if item.icon_empty:
			item_icon.texture = item.icon_empty
		else:
			modulate = Color(0.5, 0.5, 0.5)
