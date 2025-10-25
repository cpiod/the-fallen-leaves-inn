extends Node2D

var selected_item: Node
var screen_size: Vector2
var initial_mouse_pos: Vector2

const COLLISION_MASK_ITEM = 2

func _process(_delta: float) -> void:
	if selected_item:
		var mouse_pos = get_global_mouse_position()
		selected_item.position = Vector2(mouse_pos.x - initial_mouse_pos.x, mouse_pos.y - initial_mouse_pos.y)

func _input(event):
	# left click
	# only possible during player turn
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		initial_mouse_pos = get_global_mouse_position()
		if event.pressed: #clicked
			var item: Node = find_card()
			if item:
#				$"../SelectCardSound".play()
				selected_item = item
		elif selected_item: # released
			selected_item.position = Vector2(0,0)
			selected_item = null
			#if is_over_board() and $"..".can_play(selected_card):
				#$"../PlayCardSound".play()
				#$"../Hand".remove_card(selected_card)
				#$"..".play_card(selected_card)
			#elif is_over_discard():
				#$"../DiscardSound".play()
				#print("Discard")
				#$"../Hand".remove_card(selected_card)
				#$"..".discard_card(selected_card)
			#elif not $"..".can_play(selected_card):
				#$"../CantPlaySound".play()
				#print("No overlap")
				#selected_card.position = initial_pos
			#else:
				#selected_card.position = initial_pos
			#selected_card = null

func find_card() -> Node:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_ITEM
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent().get_parent() # get the card (parent of Area2D)
	return null

func _ready() -> void:
	screen_size = get_viewport_rect().size
