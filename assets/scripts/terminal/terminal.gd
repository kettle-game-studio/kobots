@tool
extends Node3D
class_name Terminal

@export var robot: RobotController
@export var monitor: MeshInstance3D
@export var color: Color
@export var meshes: Array[MeshInstance3D]

signal enter()
signal exit()

func set_color(cl: Color = color):
	color = cl
	for mesh in meshes:
		var material = mesh.get_surface_override_material(0) as ShaderMaterial
		material = material.duplicate()
		material.set_shader_parameter("color", color)
		mesh.set_surface_override_material(0, material)
		
func _update_texture():
	if monitor == null or robot == null:
		return
	# monitor.set_instance_shader_parameter("camera_texture", robot.subViewport.get_texture())
	
	var material = monitor.get_surface_override_material(0) as ShaderMaterial
	material = material.duplicate()
	material.set_shader_parameter("camera_texture", robot.subViewport.get_texture())
	monitor.set_surface_override_material(0, material)
	# monitor.set_instance_shader_parameter("test", 0.5)

func _ready():
	robot.set_color(color)
	set_color()
	_update_texture()

func _process(delta):
	if not Engine.is_editor_hint(): return
	_update_texture()
	set_color()

func enable(player: PlayerController) -> bool:
	if robot.activate(player, self):
		enter.emit()
		return true
	return false

func on_disable():
	exit.emit()
