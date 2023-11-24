extends Node3D

@export var animation_player: AnimationPlayer
@export var body: CharacterBody3D
@export var controller: PlayerController

func _ready():
	pass

func _process(_delta):
	if controller.state == PlayerController.State.DISABLED:
		return

	if body.velocity.length() > 0.001:
		animation_player.current_animation = "walk"
		animation_player.speed_scale = 2
	elif controller.is_rotationg:
		animation_player.current_animation = "walk"
		animation_player.speed_scale = 1
	else:
		animation_player.current_animation = "idle"
		animation_player.speed_scale = 0.5
