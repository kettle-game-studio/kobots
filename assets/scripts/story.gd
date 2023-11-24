extends Node

@export var cut_scenes: AnimationPlayer
@export var animation_speed: float = 1

@export var fps_text: RichTextLabel

var disable_story: bool = false

@export var level_1: Node3D
@export var level_2: Node3D
@export var level_3: Node3D
@export var level_4: Node3D

@export var start_button: Button

@onready var levels = [level_1, level_2, level_3, level_4]

func _ready():
	cut_scenes.play("level_start", -1, 0)

func start_the_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_button.visible = false
	start_button.disabled = true
	cut_scenes.play("level_start", -1, animation_speed)
	disable_story = true

func _process(delta):
	fps_text.text = "[right]%d fps[/right]" % Performance.get_monitor(Performance.TIME_FPS)
	
	if disable_story:
		return
	
	if Input.is_action_just_pressed("Debug"):
		disable_story = true
		cut_scenes.play("level_end", -1, animation_speed)

func _input(event: InputEvent):
	if !disable_story: return

	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Input.is_action_just_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func enable_for_animation():
	disable_story = false

func set_state_all_children(node: Node, state: bool):
	for child in node.get_children(true):
		child.set_process(state)
		child.set_physics_process(state)
		child.set_process_input(state)
		set_state_all_children(child, state)

func _on_level_enter(idx):
	for i in 4:
		if idx != i + 1:
			levels[i].visible = false
			set_state_all_children(levels[i], false)

func _on_level_exit(idx):
	for i in 4:
		if idx != i + 1:
			levels[i].visible = true
			set_state_all_children(levels[i], true)

