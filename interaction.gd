extends RayCast3D

func _process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider:
			if collider.get_parent().is_in_group("item") and Input.is_action_pressed("collect"):
				Inventory.add_item(collider.get_parent().item_data)
				collider.get_parent().queue_free()
			if collider.is_in_group("enemy") and Input.is_action_just_pressed("left_click"):
				collider.damage(20)
