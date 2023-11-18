@tool
extends Node3D

@export var target: Node3D

func _process(_delta: float):
	if target == null:
		return
	transform = target.global_transform
