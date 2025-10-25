extends Node2D

enum ITEM_TYPE { COMESTIBLE, AUTRE };

var selected: bool = false
@export var sprite: Texture2D
@export var title: String
@export var desc: String
@export var type: ITEM_TYPE
@export var day: int

#func set_title_desc(n: String, d: String) -> void:
#	$Bulle.text = n+": "+d
#	title = n
#	desc = d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = sprite
	$Bulle.text = title+"\n"+desc

func is_food() -> bool:
	return type == ITEM_TYPE.COMESTIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	if $"../..".can_play:
		$Bulle.visible = true

func _on_area_2d_mouse_exited() -> void:
	$Bulle.visible = false
