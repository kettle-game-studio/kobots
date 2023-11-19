extends Node
class_name PlayerController

@export var player: CharacterBody3D
@export var camera: Node3D
@export var raycast: RayCast3D
@export var robot_controller: RobotController

@export var camera_speed: float = 0.01
@export var walk_speed: float = 5
@export var push_force: float = 2

@export var flight: bool = false
@export var flight_speed: float = 5

enum State { ENABLED, DISABLED }
@export var state: State = State.DISABLED

var other: Object = null

var enabled: bool :
	get:
		return state == State.ENABLED
			

func _physics_process(delta: float):
	walk(delta)
	
	if !enabled: return
	
	for index in player.get_slide_collision_count():
		var collision = player.get_slide_collision(index)
		var collider = collision.get_collider()
		if collider is Box:
			var vector = (player.get_global_position() - collider.get_global_position()).normalized()
			collider.linear_velocity = -vector * push_force

func disactivate():
	if robot_controller != null:
		robot_controller._disactivate()

func _get_control():
	if !raycast.is_colliding():
		return
	var collider = raycast.get_collider()
	if collider is Terminal:
		if collider.enable(self):
			disable()

func _input(event: InputEvent):
	if !enabled: return
	
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_camera(event.relative)
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Input.is_action_just_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("QuitRobot"):
		disactivate()
	
	if Input.is_action_just_pressed("EnterRobot"):
		_get_control()

func rotate_camera(vector: Vector2):
	camera.rotation.x = clamp(camera.rotation.x - vector.y * camera_speed, -PI/2, PI/2)
	player.rotate_y(-vector.x * camera_speed)

func walk(delta: float):
	if !enabled:
		if !flight:
			var y_velocity = player.velocity.y - 9.8 * delta
			player.velocity = y_velocity * Vector3.UP
		else:
			player.velocity = Vector3.ZERO
			
		player.move_and_slide()
		return

	var aim = player.get_global_transform().basis
	
	var y_velocity = 0
	if flight:
		y_velocity = Input.get_axis("Descend", "Fly") * flight_speed
	else:
		y_velocity = player.velocity.y - 9.8 * delta
	
	var forward = Input.get_axis("Down", "Up") * -aim.z
	var right = Input.get_axis("Left", "Right") * aim.x
	
	var direction: Vector3 = (forward + right).normalized()
	# var 
	
	player.velocity = direction * walk_speed
	player.velocity.y = y_velocity
	player.move_and_slide()

func disable():
	state = State.DISABLED

func enable_instantly():
	state = State.ENABLED
	
func enable_next_frame():
	await get_tree().process_frame
	state = State.ENABLED
