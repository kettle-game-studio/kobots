extends Node

enum State {UNPRESSED, PRESSING, UNPRESSING, PRESSED, ALWAYS_PRESSED}

@export var button: CSGMesh3D
@export var area: Area3D
@export var press_seconds: float = 0.5

@export var pressed_albedo: Color
@export var unpressed_albedo: Color

var state: State = State.UNPRESSED
var pressiness = 0

func _ready():
	button.material = button.material.duplicate()
	button.material.albedo_color = unpressed_albedo

func _process(_delta: float):
	match state:
		State.PRESSING:
			pressiness += _delta * 1 / press_seconds
			if pressiness >= 1:
				pressiness = 1
				print("PRESS")
				button.material.albedo_color = pressed_albedo
				state = State.PRESSED
		State.UNPRESSING:
			pressiness -= _delta * 1 / press_seconds
			if pressiness <= 0:
				pressiness = 0
				print("UNPRESS")
				button.material.albedo_color = unpressed_albedo
				state = State.UNPRESSED

func _physics_process(_delta: float):
	if is_pressed():
		on_pressed()
	else:
		on_unpressed()
	
func is_pressed() -> bool:
	for body in area.get_overlapping_bodies():
		if body is RigidBody3D:
			return true
	return false

func on_pressed():
	match state:
		State.UNPRESSED:
			state = State.PRESSING

func on_unpressed():
	match state:
		State.PRESSED:
			state = State.UNPRESSING
