extends Control

@onready var icon = $Texture

var required_tags: Array[String] = []
var is_active: bool = false

func _ready() -> void:
	set_visual_state(false)
	icon.size = Vector2(App.cell_size,App.cell_size)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	# Rysujemy celownik w punkcie (0,0) lokalnie (czyli tam gdzie global_position)
	draw_circle(Vector2.ZERO, 3.0, Color.BLUE) 
	
	# Rysujemy celownik na ŚRODKU prostokąta (to jest to, czego chcemy)
	draw_circle(size / 2.0, 3.0, Color.RED)

func set_visual_state(active: bool) -> void:
	is_active = active
	if is_active:
		icon.texture = preload("res://assets/otherAssets/ballFullAtlas.tres")
	else:
		icon.texture = preload("res://assets/otherAssets/ballEmptyAtlas.tres")

func check_resource(neighbor_res: Item) -> bool:
	if neighbor_res == null: return false
	
	# Jeśli sąsiad ma CHOCIAŻ JEDEN pasujący tag -> Sukces
	for tag in required_tags:
		if neighbor_res.my_tags.has(tag):
			return true
	return false
