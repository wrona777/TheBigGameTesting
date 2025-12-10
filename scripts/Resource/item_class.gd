extends Resource
class_name Item

#Base stats
@export var name : String = "Item"
@export var icon : Texture2D
@export var size : Vector2i = Vector2i(1,1)
@export var grids : String

@export var item_offset_type = "classic_item"
var additional_offset_array = { #additional offsets for some items, 0, 90, 180, 270 respectively
	"classic_item" : [Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)],
	"L" : [Vector2(-1,-1), Vector2(2,-1), Vector2(2,2), Vector2(-1,2)]}

#Item progress bar things
@export var base_cooldown : float = 5.0
@export var fill_min_y : float = 0.0
@export var fill_max_y : float = 1.0
@export var fill_strength : float = 0.5

# ---- EFFECT CONFIG ----
@export var effects: Array[ItemEffect] = []
