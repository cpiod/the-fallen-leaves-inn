extends Node2D

var selected_item: Node
var screen_size: Vector2
var initial_mouse_pos: Vector2
var initial_item_pos: Vector2

var selected_food_item: Node
var selected_food_item_initial_pos: Vector2
var selected_other_item: Node
var selected_other_item_initial_pos: Vector2

const COLLISION_MASK_ITEM = 2
const COLLISION_MASK_DROP = 4

var can_play = true
var day: int = -1
var tries: int
var client: Node
var end: bool = false

# ordre des clients
var clients: Array
var satisfied: Array = [false, false, false, false]

func start_dialog(label: String = ""):
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	can_play = false
	Dialogic.start(client.timeline, label)
	
func start_new_day():
	var tween = get_tree().create_tween()
	var tween_item = get_tree().create_tween().set_parallel()

	if selected_food_item:
		tween_item.tween_property(selected_food_item, "position:x", selected_food_item_initial_pos.x, 1).set_trans(Tween.TRANS_SINE)
		tween_item.tween_property(selected_food_item, "position:y", selected_food_item_initial_pos.y, 1).set_trans(Tween.TRANS_SINE)
#		selected_food_item.position = selected_food_item_initial_pos
		selected_food_item = null
	if selected_other_item:
		tween_item.tween_property(selected_other_item, "position:x", selected_other_item_initial_pos.x, 1).set_trans(Tween.TRANS_SINE)
		tween_item.tween_property(selected_other_item, "position:y", selected_other_item_initial_pos.y, 1).set_trans(Tween.TRANS_SINE)
#		selected_other_item.position = selected_other_item_initial_pos
		selected_other_item = null
	day += 1
	if client:
		tween.tween_property(client, "position:x", -450, 1)
#		tween.tween_property(client, "position:x", -450, 1) # wait a second
	client = clients[day]
#	for c in clients:
#		c.visible = false
#	client.visible = true
	tween.tween_property(client, "position:x", -150, 1).set_delay(1.0)
	tween.tween_callback(start_dialog)#.set_delay(0.5)
	for c in $Items.get_children():
		if c.day == day:
			var old_pos = c.position
			var distance = sqrt(c.position.x ** 2 + c.position.y ** 2)
			c.position.x = c.position.x / distance * 500
			c.position.y = c.position.y / distance * 500
			tween_item.tween_property(c, "position:x", old_pos.x, 1).set_trans(Tween.TRANS_SINE)
			tween_item.tween_property(c, "position:y", old_pos.y, 1).set_trans(Tween.TRANS_SINE)
			c.visible = true
		elif c.day > day:
			c.visible = false
#		c.visible = c.day <= day
	tries = 0
#	start_dialog()

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	can_play = true
	if end:
		client.set_flip()
		start_new_day()
		end = false

func _process(_delta: float) -> void:
	if selected_item:
		var mouse_pos = get_global_mouse_position()
		selected_item.position = Vector2(mouse_pos.x - initial_mouse_pos.x + initial_item_pos.x, mouse_pos.y - initial_mouse_pos.y + initial_item_pos.y)

func is_over_drop_zone() -> bool:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_DROP
	return space_state.intersect_point(parameters).size() > 0

func _input(event):
	var tween = get_tree().create_tween().set_parallel()
	# left click
	# only possible during player turn
	if can_play and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		initial_mouse_pos = get_global_mouse_position()
		if event.pressed: #clicked
			var item: Node = find_item()
			if item:
#				$"../SelectCardSound".play()
				selected_item = item
				initial_item_pos = selected_item.position
		elif selected_item: # released
			if is_over_drop_zone():
				if selected_item.is_food():
					# l’item n’a peut-être pas bougé de la zone de dépose
					if selected_food_item != selected_item:
						if selected_food_item: # range l’item précédent
#							selected_food_item.position = selected_food_item_initial_pos
							tween.tween_property(selected_food_item, "position", selected_food_item_initial_pos, 0.2)
						selected_food_item = selected_item
						selected_food_item_initial_pos = initial_item_pos
					tween.tween_property(selected_item, "position", $"Dépose/FoodItemPos".position, 0.1)
#					selected_item.position = $"Dépose/FoodItemPos".position
				else:
					if selected_other_item != selected_item:
						if selected_other_item: # range l’item précédent
#							selected_other_item.position = selected_other_item_initial_pos
							tween.tween_property(selected_other_item, "position", selected_other_item_initial_pos, 0.2)
						selected_other_item = selected_item
						selected_other_item_initial_pos = initial_item_pos
					tween.tween_property(selected_item, "position", $"Dépose/OtherItemPos".position, 0.1)
#					selected_item.position = $"Dépose/OtherItemPos".position
				if selected_food_item and selected_other_item:
					$"Dépose/BoutonValider".disabled = false
			else:
				if selected_item == selected_food_item:
					initial_item_pos = selected_food_item_initial_pos
					selected_food_item = null
					$"Dépose/BoutonValider".disabled = true
				elif selected_item == selected_other_item:
					initial_item_pos = selected_other_item_initial_pos
					selected_other_item = null
					$"Dépose/BoutonValider".disabled = true
#				selected_item.position = initial_item_pos
				tween.tween_property(selected_item, "position", initial_item_pos, 0.1)
			selected_item = null

func find_item() -> Node:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_ITEM
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func _ready() -> void:
	screen_size = get_viewport_rect().size
	clients = [$Fantome, $Loup, $Fée, $Cyclope]
	start_new_day()


func _on_texture_button_pressed() -> void:
	end = false
	var edible_correct = selected_food_item.title == client.wanted_food
	var other_correct = selected_other_item.title == client.wanted_other
	if edible_correct and other_correct:
		satisfied[day] = true
		end = true
		start_dialog("2-correct")
	elif tries == 1:
		end = true
		start_dialog("2nd-error")
	elif !edible_correct and !other_correct:
		start_dialog("0-correct")
	elif edible_correct:
		start_dialog("wrong-other")
	elif other_correct:
		start_dialog("wrong-edible")
	tries += 1
