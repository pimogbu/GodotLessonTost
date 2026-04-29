extends CharacterBody3D

@onready var player: CharacterBody3D = $"."
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera3d: Camera3D = $CameraPivot/Camera3D
@onready var ray: RayCast3D = $CameraPivot/InteractionRay

@export_group("Camera")
@export var mouse_sensitivity : float = 1

@export_group("Movement")
@export var move_speed : float = 5.0
@export var acceleration : float = 20.0
@export var JUMP_VELOCITY : float = 15.0

var camera_input_direction : Vector2 = Vector2.ZERO

# Stamina Değişkenleri
var SPRINT_SPEED : float = 8.0
var WALK_SPEED : float = 5.0
var stamina : float = 100.0
var initial_stamina: float = 100.0 

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion : bool = (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_camera_motion:
		camera_input_direction = event.screen_relative * mouse_sensitivity
		
	if event.is_action_pressed("jump") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("sprint") and stamina > 0:
		move_speed = SPRINT_SPEED
		stamina -= 10.0 * delta
	else:
		move_speed = WALK_SPEED 
		stamina += 2.0 * delta
		stamina = clamp(stamina, 0, initial_stamina)
	
	# KAMERA HAREKETLERI
	camera_pivot.rotation.x -= camera_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 3.0, PI / 1.5)
	camera_pivot.rotation.y -= camera_input_direction.x * delta 
	camera_input_direction = Vector2.ZERO 
	
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
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("six"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Alanıma girdin")
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	print("Alanımdan cıktın")

func _on_area_3d_mouse_entered() -> void:
	print("beni dürtme")
