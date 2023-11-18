extends Node

@export var player: CharacterBody3D
@export var camera: Node3D
@export var raycast: RayCast3D

@export var camera_speed: float = 0.01
@export var walk_speed: float = 5
@export var push_force: float = 100

@export var enabled: bool = false

func _physics_process(delta: float):
	if !enabled: return
	
	walk(delta)
	for index in player.get_slide_collision_count():
		var collision = player.get_slide_collision(index)
		var collider = collision.get_collider()
		if collider is RigidBody3D:
			var vector = (player.get_position() - collider.get_position()).normalized()
			collider.apply_central_force(-vector * push_force)

func _get_control():
	if not raycast.is_colliding():
		return
	var collider = raycast.get_collider()
	if collider is Terminal:
		collider.enable()

func _input(event: InputEvent):
	if !enabled: return
	
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_camera(event.relative)
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.button_index == MOUSE_BUTTON_LEFT:
			_get_control()

	if Input.is_action_just_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func rotate_camera(vector: Vector2):
	camera.rotation.x = clamp(camera.rotation.x - vector.y * camera_speed, -PI/2, PI/2)
	player.rotate_y(-vector.x * camera_speed)

func walk(_delta: float):
	var aim = player.get_global_transform().basis
	
	var forward = Input.get_axis("Down", "Up") * -aim.z
	var right = Input.get_axis("Left", "Right") * aim.x
	
	var direction: Vector3 = (forward + right).normalized()
	
	player.velocity = direction * walk_speed
	player.move_and_slide()

