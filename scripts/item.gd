extends Node2D

var selected: bool = false
@export var sprite: Texture2D
@export var title: String
@export var desc: String

#func set_title_desc(n: String, d: String) -> void:
#	$Bulle.text = n+": "+d
#	title = n
#	desc = d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = sprite
	$Bulle.text = title+"\n"+desc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	$Bulle.visible = true

func _on_area_2d_mouse_exited() -> void:
	$Bulle.visible = false
