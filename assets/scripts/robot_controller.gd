@tool
extends Node3D
class_name RobotController

@export var subViewport: SubViewport
@export var player_controller: PlayerController
@export var canvas_layer: CanvasLayer
@export var can_push_buttons: bool = false

var parent: PlayerController

func _ready():
	_disactivate()

func _disactivate():
	subViewport.disable_3d = true
	if not Engine.is_editor_hint():
		player_controller.disable()
	if parent != null:
		parent.enable_next_frame()
	parent = null

func activate(parent: PlayerController) -> bool:
	if player_controller.enabled:
		return false
		
	self.parent = parent
	player_controller.enable_next_frame()
	subViewport.disable_3d = false
	return true

func _process(delta):
	if canvas_layer == null or subViewport == null:
		update_configuration_warnings()
		return

	# 16 / 9
	var sz = DisplayServer.window_get_size()
	sz.y = max(sz.y, 600)
	if sz.x * 9 < sz.y * 16:
		sz.x = sz.y * 16 / 9
	else:
		sz.y = sz.x * 9 / 16
	var canvas_scale = sz.y / 600.0
	canvas_layer.scale = Vector2(canvas_scale, canvas_scale)
	subViewport.size = sz


func _get_configuration_warnings():
	var warnings = []
	if canvas_layer == null or subViewport == null:
		warnings.append("wrong robot_controller parameters!!")
	return warnings

