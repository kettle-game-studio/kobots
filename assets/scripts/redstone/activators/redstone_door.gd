extends RedstoneAbstractActivator

@export var mesh: MeshInstance3D
@export var color: Color
@export var seconds_to_open: float = 1
var activators: Array[RedstoneAbstractActivator] = []

var receiver_children: Array[RedstoneBase] = []
var material: ShaderMaterial

@onready var animator = $AnimationPlayer
@onready var solved_sound = $SolvedSound
@onready var open_sound = $OpenSound

func _ready():
	super._ready()
	material = mesh.get_surface_override_material(0).duplicate(true) as ShaderMaterial
	material.set_shader_parameter("color", color)
	mesh.set_surface_override_material(0, material)
	for i in children:
		i.set_redstone_material(material)
		if i is RedstoneAbstractActivator:
			activators.push_back(i)


func _process(_delta):
	if is_activates:
		return
	for i in activators:
		if not i.is_activates:
			return
	is_activates = true
	for i in activators:
		i.freeze_activation()
	material.set_shader_parameter("emission_k", 1.0)
	animator.play("opening", -1, 1 / seconds_to_open)
	solved_sound.play(0)
	open_sound.play(0)


func set_redstone_material(m: Material):
	material = m
	super.set_redstone_material(m)
	mesh.set_surface_override_material(0, m)
	
