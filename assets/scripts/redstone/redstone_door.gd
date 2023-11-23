extends RedstoneLine

@export var mesh: MeshInstance3D
@export var color: Color
@export var seconds_to_open: float = 1

var activators: Array[RedstoneAbstractActivator] = []
var receiver_children: Array[RedstoneBase] = []
var material: ShaderMaterial
var is_activated = false
@onready var animator = $AnimationPlayer

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
	if is_activated:
		return
	for i in activators:
		if not i.is_activates:
			return
	is_activated = true
	for i in activators:
		i.freeze_activation()
	material.set_shader_parameter("emission_k", 1.0)
	animator.play("opening", -1, 1 / seconds_to_open)


func set_redstone_material(_m: Material):
	push_warning("door.set_redstone_material")
