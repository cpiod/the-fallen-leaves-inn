extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var feuille = $Feuille
	var tween_translate = get_tree().create_tween().set_parallel()
	var tween_rotate = get_tree().create_tween()
	tween_translate.tween_property(feuille, "position:x", 500, 8)
	tween_translate.tween_property(feuille, "position:y", 800, 8)
	tween_rotate.tween_property(feuille, "rotation", 1.2, 2).set_trans(Tween.TRANS_SINE)
	tween_rotate.tween_property(feuille, "rotation", -2, 2).set_trans(Tween.TRANS_SINE)
	tween_rotate.tween_property(feuille, "rotation", -.2, 2).set_trans(Tween.TRANS_SINE)
	tween_rotate.tween_property(feuille, "rotation", 2, 2).set_trans(Tween.TRANS_SINE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/jeu.tscn")


func _on_credits_2_mouse_exited() -> void:
	$NinePatchRect.visible = false

func _on_credits_2_mouse_entered() -> void:
	$NinePatchRect.visible = true
