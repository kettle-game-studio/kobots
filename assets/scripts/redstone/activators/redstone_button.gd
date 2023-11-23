extends RedstoneAbstractActivator


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
var redstone_material: ShaderMaterial

var material: Material : 
	get:
		return button.get_surface_override_material(0)
	set(value):
		button.set_surface_override_material(0, value)

func _ready():
	super._ready()
	material = material.duplicate()
	_disable_activate_color()

func _process(_delta: float):
	match state:
		State.PRESSING:
			pressiness += _delta * 1 / press_seconds
			if pressiness >= 1:
				pressiness = 1
				_enable_activate_color()
				state = State.PRESSED
		State.UNPRESSING:
			pressiness -= _delta * 1 / press_seconds
			if pressiness <= 0:
				pressiness = 0
				_disable_activate_color()
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

func freeze_activation():
	state = State.ALWAYS_PRESSED

func set_redstone_material(material: Material):
	redstone_material = material.duplicate()
	super.set_redstone_material(redstone_material)

func _enable_activate_color():
	is_activates = true
	material.albedo_color = pressed_albedo
	if redstone_material != null:
		redstone_material.set_shader_parameter("emission_k", 1.0)
	

func _disable_activate_color():
	is_activates = false
	material.albedo_color = unpressed_albedo
	if redstone_material != null:
		redstone_material.set_shader_parameter("emission_k", 0.3)

