extends CharacterBody3D

@onready var player: CharacterBody3D = $"."
@onready var camera3d: Camera3D = $CameraPivot/Camera3D

@export_group("Movement")
@export var move_speed : float = 5.0
@export var acceleration : float = 20.0
@export var JUMP_VELOCITY : float = 15.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
		
func _physics_process(delta: float) -> void:
	# Yerçekimi
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta * 5.0
		
	# HAREKET
	var raw_input : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward : Vector3 = camera3d.global_basis.z
	var right : Vector3 = camera3d.global_basis.x
	
	var move_direction : Vector3 = (forward * raw_input.y + right * raw_input.x)
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
		# Hedef hıza doğru ivmelenme (Move Toward)
	player.velocity.x = move_toward(player.velocity.x, move_direction.x * move_speed, acceleration * delta)
	player.velocity.z = move_toward(player.velocity.z, move_direction.z * move_speed, acceleration * delta)
	  
	player.move_and_slide()
