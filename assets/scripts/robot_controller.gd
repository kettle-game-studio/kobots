@tool
extends Node3D
class_name RobotController

@export var subViewport: SubViewport
@export var player_controller: PlayerController

func _ready():
	_disactivate()

func _disactivate():
	subViewport.disable_3d = true
	player_controller.enabled = false

func activate() -> bool:
	if player_controller.enabled:
		return false
	push_warning("robot enabled!!!")
	player_controller.enabled = true
	subViewport.disable_3d = false
	return true

