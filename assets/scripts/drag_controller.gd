extends Node

enum State { NOT_DRAGGING, DRAGGING }

@export var player: CharacterBody3D
@export var player_controller: PlayerController
@export var ray_cast: RayCast3D
@export var camera: Node3D 
@export var box_mount_point: Node3D
@export var box_collision: CollisionShape3D 
@export var drag_speed: float = 1
@export var camera_speed: float = 0.001

var state: State = State.NOT_DRAGGING
var dragged_box: Box = null

func _ready():
	box_collision.disabled = true

func _process(delta: float):
	walk(delta)

func _input(event: InputEvent):
	if Input.is_action_just_pressed("DragBox"):
		on_drag_box()
		
	if state != State.DRAGGING: return
	
	if Input.is_action_just_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_camera(event.relative)
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("QuitRobot"):
		stop_dragging()
		player_controller.disactivate()

func rotate_camera(vector: Vector2):
	camera.rotation.x = clamp(camera.rotation.x - vector.y * camera_speed, -PI/2, PI/2)
	player.rotate_y(-vector.x * camera_speed)


func walk(delta: float):
	if state != State.DRAGGING:
		return
	
	var aim = player.get_global_transform().basis
	
	var y_velocity = player.velocity.y - 9.8 * delta
	
	var forward = Input.get_axis("Down", "Up") * -aim.z
	var right = Input.get_axis("Left", "Right") * aim.x
	
	var direction: Vector3 = (forward + right).normalized()
	
	
	player.velocity = direction * drag_speed
	player.velocity.y = y_velocity
	
	player.move_and_slide()
	dragged_box.global_transform = box_mount_point.global_transform

func on_drag_box():
	match state:
		State.DRAGGING:
			stop_dragging()
			
		State.NOT_DRAGGING:
			start_dragging()

func start_dragging():
	if !ray_cast.is_colliding():
		return
	var collider = ray_cast.get_collider()
	if !(collider is Box):
		return
		
	dragged_box = collider
	state = State.DRAGGING
	player_controller.disable(true)
	box_mount_point.global_transform = dragged_box.global_transform
	box_collision.global_transform = dragged_box.global_transform
	box_collision.global_position += Vector3.UP * 0.5
	box_collision.disabled = false
	dragged_box.disable_collision()
	print("start dragging ", dragged_box.box_name)

func stop_dragging():
	print("stop dragging ", dragged_box.box_name)
	player_controller.enable_instantly()
	dragged_box.enable_collision()
	box_collision.disabled = true
	state = State.NOT_DRAGGING
