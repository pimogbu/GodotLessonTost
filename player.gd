extends CharacterBody3D

@onready var player: CharacterBody3D = $"."
@export var JUMP_VELOCITY : float = 15.0

@onready var camera: Camera3D = $CameraPivot/Camera3D

#Speed variables
@onready var move_speed:float = 5.0
@onready var acceleration:float = 20.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
		
func _physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta * 5.0
	
	var raw_input : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward : Vector3 = camera.global_basis.z
	var right: Vector3 = camera.global_basis.x
	
	var move_direction : Vector3 = (forward * raw_input.y + right * raw_input.x)
	move_direction.y = 0.0
	move_direction.normalized()
	
	player.velocity.x = move_toward(player.velocity.x, move_direction.x * move_speed, acceleration * delta)
	player.velocity.z = move_toward(player.velocity.z, move_direction.z * move_speed, acceleration * delta)
	player.move_and_slide()
