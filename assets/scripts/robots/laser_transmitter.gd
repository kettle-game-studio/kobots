@tool
extends Node
@export var laser_mesh: MeshInstance3D
@export var color: Color
@export var animation_player: AnimationPlayer

var laser_material: ShaderMaterial

func _init_material():
	var material = laser_mesh.get_surface_override_material(0) as ShaderMaterial
	laser_material = material.duplicate()
	laser_material.set_shader_parameter("color", color)
	laser_mesh.set_surface_override_material(0, laser_material)


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("work")


func _check_correction():
	return animation_player == null


func _process(delta):
	if _check_correction():
		update_configuration_warnings()
		return
	if Engine.is_editor_hint():
		_init_material()


func _get_configuration_warnings():
	var warnings = []
	if _check_correction():
		warnings.append("wrong parameters!!")
	return warnings
