extends Node2D

enum ITEM_TYPE { COMESTIBLE, AUTRE };

var selected: bool = false
@export var sprite: Texture2D
@export_multiline var title: String
@export_multiline var desc: String
@export var type: ITEM_TYPE
@export var day: int

#func set_title_desc(n: String, d: String) -> void:
#	$Bulle.text = n+": "+d
#	title = n
#	desc = d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = sprite
	$MarginContainer/Bulle.text = title+"\n"+desc

func is_food() -> bool:
	return type == ITEM_TYPE.COMESTIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	if $"../..".can_play:
		$MarginContainer.visible = true

func _on_area_2d_mouse_exited() -> void:
	$MarginContainer.visible = false
