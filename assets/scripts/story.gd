extends Node

@export var fps_text: RichTextLabel

@export var level_1: Node3D
@export var level_2: Node3D
@export var level_3: Node3D
@export var level_4: Node3D

@onready var levels = [level_1, level_2, level_3, level_4]

func _process(delta):
	fps_text.text = "[right]%d fps[/right]" % Performance.get_monitor(Performance.TIME_FPS)

func _ready():
	pass

func set_state_all_children(node: Node, state: bool):
	for child in node.get_children(true):
		child.set_process(state)
		child.set_physics_process(state)
		set_state_all_children(child, state)

func _on_level_enter(idx):
	for i in 4:
		set_state_all_children(levels[i], i + 1 == idx)

func _on_level_exit(idx):
	for i in 4:
		if idx != i + 1:
			set_state_all_children(levels[i], true)

