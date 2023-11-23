extends RedstoneAbstractActivator
class_name RedstoneLaserReceiver

@export var meshes: Array[MeshInstance3D]

var materials: Array[ShaderMaterial] = []
var freezed: bool = false

func _ready():
	for mesh in meshes:
		var material = mesh.get_surface_override_material(0) as ShaderMaterial
		material = material.duplicate()
		material.set_shader_parameter("enable", true)
		mesh.set_surface_override_material(0, material)
		materials.push_back(material)
	_disable_materials()


func enable_laser(color: Color):
	is_activates = true
	for material in materials:
		material.set_shader_parameter("emission_k", 1.1)
		material.set_shader_parameter("emission_period", 7)
		material.set_shader_parameter("emission_amplitude", 0.3)
		material.set_shader_parameter("color", color)


func disable_laser():
	if freezed:
		return
	is_activates = false
	_disable_materials()

func _disable_materials():
	for material in materials:
		material.set_shader_parameter("emission_k", 0.05)
		material.set_shader_parameter("emission_period", 2)
		material.set_shader_parameter("emission_amplitude", 0.05)

func freeze_activation():
	freezed = true
