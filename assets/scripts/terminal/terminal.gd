@tool
extends Node3D
class_name Terminal

@export var robot: RobotController
@export var monitor: MeshInstance3D

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
	_update_texture()

func _process(delta):
	if not Engine.is_editor_hint(): return
	_update_texture()

func enable() -> bool:
	push_warning("terminal enabled!!!")
	return robot.activate()
