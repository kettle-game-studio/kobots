extends Node
class_name PlayerController

@export var player: CharacterBody3D
@export var camera: Node3D
@export var raycast: RayCast3D
@export var robot_controller: RobotController
@export var scheme_ui: CanvasLayer
@export var main_ui: UICanvas
@export var audio_listener: AudioListener3D

@export var camera_speed: float = 0.003
@export var walk_speed: float = 5
@export var push_force: float = 2

@export var flight: bool = false
@export var flight_speed: float = 5

@export var can_push: bool = false

@export var can_run: bool = false
@export var run_multiplyer: float = 2

enum State { ENABLED, DISABLED, CONTROLLED_BY_OTHER }
@export var state: State = State.DISABLED

@export var clamp_angle_up: float = 180
@export var clamp_angle_down: float = 180

@export var standing_detector: ShapeCast3D

@onready var distortion = AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 0) as AudioEffectDistortion

var other: Object = null
var is_rotationg = false
var rotating_timer = 0

var enabled: bool :
	get:
		return state == State.ENABLED

func _ready():
	if main_ui:
		main_ui.visible = false

func _physics_process(delta: float):
	walk(delta)
	
	if !enabled || !can_push: return
	
	for index in player.get_slide_collision_count():
		var collision = player.get_slide_collision(index)
		var collider = collision.get_collider()
		if collider is Box:
			var vector = (player.get_global_position() - collider.get_global_position()).normalized()
			collider.linear_velocity = -vector * push_force

func disactivate():
	if robot_controller != null:
		robot_controller._disactivate()

func _get_control(terminal: Terminal):
	if terminal.enable(self):
		if main_ui:
			main_ui.disable()
		if !robot_controller && scheme_ui:
			scheme_ui.visible = true
		disable(true)

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
	
	if !raycast.is_colliding():
		main_ui.clear_text()
		return

	var collider = raycast.get_collider()
	if collider is Terminal:
		main_ui.set_text("[E] To Activate")
		if Input.is_action_just_pressed("EnterRobot"):
			_get_control(collider)
	else:
		main_ui.clear_text()

func rotate_camera(vector: Vector2):
	var window_size = DisplayServer.window_get_size()
	self.is_rotationg = true
	self.rotating_timer = 0.02
	var velocity = vector.y * camera_speed
	camera.rotation.x = clamp(camera.rotation.x - velocity, -clamp_angle_down / 180 * PI / 2, clamp_angle_up / 180 * PI / 2)
	player.rotate_y(-vector.x * camera_speed)

func walk(delta: float):
	if !enabled:
		player.velocity = gravity(delta) * Vector3.UP
		player.move_and_slide()
		return

	var aim = player.get_global_transform().basis
	
	var y_velocity = gravity(delta)
	
	var forward = Input.get_axis("Down", "Up") * -aim.z
	var right = Input.get_axis("Left", "Right") * aim.x
	
	var direction: Vector3 = (forward + right).normalized()
	
	if can_run && Input.is_action_pressed("Descend"):
		direction *= run_multiplyer
	
	player.velocity = direction * walk_speed
	player.velocity.y = y_velocity
	player.move_and_slide()

func gravity(delta: float) -> float:
	if standing_detector:
		for i in standing_detector.get_collision_count():
			var collider = standing_detector.get_collider(i)
			if collider is RobotController:
				return player.velocity.y - (9.8 / 2.0) * delta
	
	if flight:
		if state == State.DISABLED:
			return 0
		return Input.get_axis("Descend", "Fly") * flight_speed
	
	return player.velocity.y - 9.8 * delta

func _process(delta):
	if self.rotating_timer <= 0:
		self.rotating_timer = 0
		self.is_rotationg = 0
	else:
		self.rotating_timer -= delta

func disable(controlled_by_other: bool = false):
	if controlled_by_other:
		state = State.CONTROLLED_BY_OTHER
	else:
		state = State.DISABLED
		audio_listener.clear_current()
		if scheme_ui:
			scheme_ui.visible = true
		if main_ui:
			main_ui.disable()

func enable_instantly():
	enable_audio()
	if scheme_ui:
		scheme_ui.visible = false
	if main_ui:
		main_ui.enable()
	state = State.ENABLED
	
func enable_next_frame():
	await get_tree().process_frame
	enable_instantly()

func get_depth():
	if !robot_controller:
		return 0
	return robot_controller.depth

func enable():
	enable_audio()
	main_ui.visible = true
	state = State.ENABLED

func disable_for_animation():
	main_ui.visible = false
	state = State.DISABLED

var distortion_drive_by_depths = [0, 0.6, 0.7, 0.8, 0.85, 0.9, 0.93, 0.95, 1.]
var distortion_post_gain_by_depths = [0, 0, 0, 0, -6, -10, -10,-10, -10]

func enable_audio():
	var depth = get_depth()
	print(depth)
	distortion.drive = distortion_drive_by_depths[depth]
	distortion.post_gain = distortion_post_gain_by_depths[depth]
	audio_listener.make_current()
