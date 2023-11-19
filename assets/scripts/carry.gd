extends Node

@export var mount_point: Node3D
@export var platfrom_body: AnimatableBody3D

func _physics_process(_delta: float):
	platfrom_body.global_position = mount_point.global_position
