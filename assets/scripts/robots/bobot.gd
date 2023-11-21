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
		var is_walk = false
		if body.velocity.length() > 0.001:
			is_walk = true
			animation_player.speed_scale = 2
		elif controller.is_rotationg:
			is_walk = true
			animation_player.speed_scale = 1
		else:
			animation_player.speed_scale = 0.5

		if is_walk:
			if controller.state == PlayerController.State.CONTROLLED_BY_OTHER:
				animation_player.current_animation = "walk_box"
			else:
				animation_player.current_animation = "walk"
		else:
			if controller.state == PlayerController.State.CONTROLLED_BY_OTHER:
				animation_player.current_animation = "idle_box"
			else:
				animation_player.current_animation = "idle"

func _get_configuration_warnings():
	var warnings = []
	if animation_player == null or body == null or controller == null:
		warnings.append("wrong bobot parameters!!")
	return warnings

