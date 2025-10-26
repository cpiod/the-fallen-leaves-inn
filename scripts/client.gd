extends Node2D

@export var wanted_food: String
@export var wanted_other: String
@export var timeline: String
@export var sprites: SpriteFrames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.sprite_frames = sprites
	$Sprite.play()

func set_flip() -> void:
	$Sprite.set_flip_h(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
