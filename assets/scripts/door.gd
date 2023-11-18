extends Node
class_name Door

@export var door: Node3D
@export var target_position: Vector3
@export var seconds_to_open: float

var start_door_position: Vector3

func _ready():
	start_door_position = door.transform.origin

func open():
	print("Start opening")
	const delta_time = 1.0 / 24.0
	var time = 0
	var moved = 0
	while time < seconds_to_open:
		time += delta_time
		await get_tree().create_timer(delta_time).timeout
		moved = time / seconds_to_open
		set_doors_positions(moved)

func set_doors_positions(moved: float):
	door.transform.origin = start_door_position + target_position * moved


func _on_button_pressed():
	open()
