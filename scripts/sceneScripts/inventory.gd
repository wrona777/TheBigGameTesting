extends Control
class_name Inventory

@export_range(1, 128) var columns: int = 8
@export_range(1, 128) var rows: int = 8
@export var slot_scene: PackedScene
@export var item_scene: PackedScene

@export var interactive : bool = true

signal items_loaded

var a_owner : Character
var a_opponent : Character

@onready var grid: GridContainer = $Grid

var slot_array : Array  #array of all slots
var item_array : Array
var can_place = false #self explainatory

func _ready() -> void:
	grid.columns = columns

func _process(_delta: float) -> void:
	if App.item_held and interactive:
		if Input.is_action_just_pressed("RightMouseClick"):
			rotate_item()
		
		if Input.is_action_just_pressed("LeftMouseClick"):
			place_item()
	
	else:
		if grid.get_global_rect().has_point(get_global_mouse_position()):
			if Input.is_action_just_pressed("LeftMouseClick"):
				pick_up()

func initialize_items(data_array : Array):
	if slot_array.is_empty():
		_spawn_slots()
		
	await get_tree().process_frame
	
	for item_info in data_array:
		clamp_item_to_slots_id(item_info["slot"], item_info["item_path"], item_info["rotation_deg"])
	
	items_loaded.emit()

func initialize_combat_logic(_owner: Character, _opponent: Character) -> void:
	a_owner = _owner
	a_opponent = _opponent
	
	for item in item_array:
		item.a_owner = a_owner
		item.a_target = a_opponent

func _spawn_slots() -> void:
	var num_of_slots = columns * rows
	
	for i in range(num_of_slots):
		var new_slot = slot_scene.instantiate()
		new_slot.slot_ID = i
		slot_array.push_back(new_slot)
		grid.add_child(new_slot)
		new_slot.slot_entered.connect(_on_slot_mouse_entered)
		new_slot.slot_exited.connect(_on_slot_mouse_exited)

func get_slot_node_at_global_pos(global_pos: Vector2) -> Control:
	for slot in slot_array:
		if slot.get_global_rect().has_point(global_pos):
			return slot
	return null

func _on_slot_mouse_entered(a_slot) -> void:
	if not interactive: return
	App.current_slot = a_slot
	if App.item_held:
		check_slot_availability(a_slot)
		set_grids.call_deferred(App.current_slot)

func _on_slot_mouse_exited(_a_slot) -> void:
	clear_grid()

func check_slot_availability(a_slot) -> void:
	for a_grid in App.item_held.item_grids:
		var grid_to_check = a_slot.slot_ID + a_grid[0] + a_grid[1] * columns
		var line_switch_check = a_slot.slot_ID % columns + a_grid[0]
		if line_switch_check < 0 or line_switch_check >= columns:
			can_place = false
			return
		if grid_to_check < 0 or grid_to_check >= slot_array.size():
			can_place = false
			return
		if slot_array[grid_to_check].item_stored != null:
			can_place = false
			return
	can_place = true

func set_grids(a_slot) -> void:
	for a_grid in App.item_held.item_grids:
		var grid_to_check = a_slot.slot_ID + a_grid[0] + a_grid[1] * columns
		var line_switch_check = a_slot.slot_ID % columns + a_grid[0]
		if grid_to_check < 0 or grid_to_check >= slot_array.size():
			continue
		if line_switch_check < 0 or line_switch_check >= columns:
			continue
		if can_place:
			slot_array[grid_to_check].set_color("Free")
		else:
			slot_array[grid_to_check].set_color("Taken")

func clear_grid() -> void:
	for a_grid in slot_array:
		a_grid.set_color("Null")

func rotate_item():
	App.item_held.rotate()
	clear_grid()
	
	if App.current_slot:
		_on_slot_mouse_entered(App.current_slot)

func place_item():
	if not can_place or not App.current_slot:
		return
	
	var slot_id = App.current_slot.slot_ID
	var slot_pos = slot_array[slot_id].global_position
	
	App.item_held._snap_item_to_inventory(slot_pos)
	App.item_held.grid_anchor = App.current_slot
	
	for a_grid in App.item_held.item_grids:
		var grid_to_check = slot_id + a_grid[0] + a_grid[1] * columns
		slot_array[grid_to_check].item_stored = App.item_held
	
	App.item_held = null
	clear_grid()

func pick_up():
	if not App.current_slot or not App.current_slot.item_stored:
		return
	
	App.item_held = App.current_slot.item_stored
	App.item_held.selected = true
	
	for a_grid in App.item_held.item_grids:
		var grid_to_check = App.item_held.grid_anchor.slot_ID + a_grid[0] + a_grid[1] * columns
		slot_array[grid_to_check].item_stored = null
	
	check_slot_availability(App.current_slot)
	set_grids.call_deferred(App.current_slot)

func clamp_item_to_slots_id(id : int, item : Item, degrees : int) -> void:
	var new_item = item_scene.instantiate()
	new_item.item = item
	add_child(new_item)
	item_array.push_back(new_item)
	new_item.inventory_ref = self
	
	var the_slot = slot_array[id]
	new_item.grid_anchor = the_slot
	
	for i in range(degrees):
		new_item.rotate()
	
	new_item._snap_item_to_inventory(the_slot.global_position)
	
	for a_grid in new_item.item_grids:
		var grid_to_check = id + a_grid[0] + a_grid[1] * columns
		slot_array[grid_to_check].item_stored = new_item

func stop_all_cooldowns() -> void:
	for item in item_array:
		item._stop_cooldown()

func start_all_cooldowns() -> void:
	for item in item_array:
		item._start_cooldown()
