extends Node
class_name Door

@export var door: Node3D
@export var seconds_to_open: float
@onready var animator = $AnimationPlayer

var start_door_position: Vector3

func open():
	animator.play("opening", -1, seconds_to_open)

func _on_button_pressed():
	open()
