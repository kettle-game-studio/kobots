extends StaticBody3D
class_name LaserAbsorber

@export var meshes: Array[MeshInstance3D]

signal pressed(LaserAbsorber)
signal unpressed(LaserAbsorber)

var materials: Array[ShaderMaterial] = []
var freezed: bool = false

func _ready():
	for mesh in meshes:
		var material = mesh.get_surface_override_material(0) as ShaderMaterial
		material = material.duplicate()
		material.set_shader_parameter("enable", false)
		mesh.set_surface_override_material(0, material)
		materials.push_back(material)


func enable_laser(color: Color):
	pressed.emit(self)
	for material in materials:
		material.set_shader_parameter("enable", true)
		material.set_shader_parameter("color", color)


func disable_laser():
	if freezed:
		return
	unpressed.emit(self)
	for material in materials:
		material.set_shader_parameter("enable", false)


func freeze_as_activated():
	freezed = true
