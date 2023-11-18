@tool
extends Node3D
class_name RobotController

@export var subViewport: SubViewport

var _activated = false

func _ready():
	_disactivate()

func _disactivate():
	subViewport.disable_3d = true
	_activated = false

func activate() -> bool:
	if _activated:
		return false
	push_warning("robot enabled!!!")
	_activated = true
	subViewport.disable_3d = false
	return true

