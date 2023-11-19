@tool
extends Node3D
class_name RobotController

@export var subViewport: SubViewport
@export var player_controller: PlayerController

var parent: PlayerController

func _ready():
	_disactivate()

func _disactivate():
	subViewport.disable_3d = true
	player_controller.disable()
	if parent != null:
		parent.enable()
	parent = null

func activate(parent: PlayerController) -> bool:
	if player_controller.enabled:
		return false
		
	self.parent = parent
	player_controller.enable()
	subViewport.disable_3d = false
	return true

