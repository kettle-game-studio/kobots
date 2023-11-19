@tool
extends Node3D

@export var color: Color
@export var enable_laser: bool
@export var meshes: Array[MeshInstance3D]
@export var light_meshes: Array[MeshInstance3D]


func _update_parameters():
	for mesh in light_meshes + meshes:
		var material = mesh.get_surface_override_material(0) as ShaderMaterial
		material = material.duplicate()
		material.set_shader_parameter("color", color)
		mesh.set_surface_override_material(0, material)
	for mesh in light_meshes:
		var material = mesh.get_surface_override_material(0) as ShaderMaterial
		material.set_shader_parameter("enable", enable_laser)


func _ready():
	_update_parameters()


func _process(delta):
	if Engine.is_editor_hint():
		_update_parameters()
	pass
