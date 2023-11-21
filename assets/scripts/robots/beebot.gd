@tool
extends Node3D

@export var color: Color
@export var meshes: Array[MeshInstance3D]
@export var animation_player: AnimationPlayer
@export var body: CharacterBody3D
@export var controller: PlayerController


func _update_parameters():
	for mesh in meshes:
		var material = mesh.get_surface_override_material(0) as ShaderMaterial
		material = material.duplicate()
		material.set_shader_parameter("color", color)
		mesh.set_surface_override_material(0, material)

func _ready():
	_update_parameters()

func _process(delta):
	if animation_player == null or body == null or controller == null:
		update_configuration_warnings()
		return
	if Engine.is_editor_hint():
		_update_parameters()
	else:
		animation_player.speed_scale = 3
		animation_player.current_animation = "fly"


func _get_configuration_warnings():
	var warnings = []
	if animation_player == null or body == null or controller == null:
		warnings.append("wrong beebot parameters!!")
	return warnings
