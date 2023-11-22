extends Node
class_name ButtonController

enum State {UNPRESSED, PRESSING, UNPRESSING, PRESSED, ALWAYS_PRESSED}

signal pressed(ButtonController)
signal unpressed(ButtonController)

@export var button: MeshInstance3D
@export var area: Area3D
@export var press_seconds: float = 0.5

@export var pressed_albedo: Color
@export var unpressed_albedo: Color

var state: State = State.UNPRESSED
var pressiness = 0

var material: Material : 
	get:
		return button.get_surface_override_material(0)
	set(value):
		button.set_surface_override_material(0, value)

func _ready():
	material = material.duplicate()
	material.albedo_color = unpressed_albedo

func _process(_delta: float):
	match state:
		State.PRESSING:
			pressiness += _delta * 1 / press_seconds
			if pressiness >= 1:
				pressiness = 1
				material.albedo_color = pressed_albedo
				state = State.PRESSED
				pressed.emit(self)
		State.UNPRESSING:
			pressiness -= _delta * 1 / press_seconds
			if pressiness <= 0:
				pressiness = 0
				material.albedo_color = unpressed_albedo
				state = State.UNPRESSED
				unpressed.emit(self)

func _physics_process(_delta: float):
	if is_pressed():
		on_pressed()
	else:
		on_unpressed()
	
func is_pressed() -> bool:
	for body in area.get_overlapping_bodies():
		if body is RigidBody3D:
			return true
		if body is RobotController:
			return body.can_push_buttons
	return false

func on_pressed():
	match state:
		State.UNPRESSED:
			state = State.PRESSING

func on_unpressed():
	match state:
		State.PRESSED:
			state = State.UNPRESSING

func freeze_as_activated():
	state = State.ALWAYS_PRESSED
