@tool
extends Node3D

@export var color: Color
@export var enable_laser: bool
@export var meshes: Array[MeshInstance3D]
@export var light_meshes: Array[MeshInstance3D]
@export var animation_player: AnimationPlayer
@export var body: CharacterBody3D
@export var controller: PlayerController


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
	if animation_player == null or body == null or controller == null:
		push_warning("wrong crab parameters!!")
		return
	if Engine.is_editor_hint():
		_update_parameters()
	else:
		if body.velocity.length() > 0.001:
			animation_player.current_animation = "walk"
			animation_player.speed_scale = 10
		elif controller.is_rotationg:
			animation_player.current_animation = "walk"
			animation_player.speed_scale = 5
		else:
			animation_player.current_animation = "idle"
			animation_player.speed_scale = 0.5


