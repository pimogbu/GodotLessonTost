extends CharacterBody3D

var _health : float = 100

func get_health() -> int:
	return _health 
	
func damage(hit : float) -> void:
	set_health(_health - hit)
	
func set_health(value:int) -> void:
	_health = clamp(value, 0, 100)
	print(_health)
	if _health <= 0:
		die()
		
func die():
	queue_free()
