extends Node
class_name Story

var total_time = -1

@export var cut_scenes: AnimationPlayer
@export var animation_speed: float = 1

@export var fps_text: RichTextLabel

var disable_story: bool = false

@export var level_1: Node3D
@export var level_2: Node3D
@export var level_3: Node3D
@export var level_4: Node3D
@export var root: Node

@export var start_button: Button
@export var speedrun_data: RichTextLabel

@export var cam: Camera3D

@onready var levels = [level_1, level_2, level_3, level_4]

var timer_start = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cut_scenes.play("level_start", -1, 0)

func start_the_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_button.visible = false
	start_button.disabled = true
	disable_story = true
	
	if Performance.get_monitor(Performance.TIME_FPS) < 20:
		await get_tree().create_timer(3).timeout
	
	timer_start = Time.get_ticks_msec()
	cut_scenes.play("level_start", -1, animation_speed)

func _process(delta):
	fps_text.text = "[right]%d fps[/right]" % Performance.get_monitor(Performance.TIME_FPS)
	
	if disable_story:
		return
	
	if Input.is_action_just_pressed("Debug"):
		level_end()

func level_end():
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

func level_finish():
	for i in 4:
		set_state_all_children(levels[i], false)
			
	kill_old_level()
	var parent = root.get_parent()
	
	var next_level_resource = load("res://assets/scenes/main_scene.tscn")
	var next_level = next_level_resource.instantiate()
	parent.add_child(next_level)
	
	var next_story = next_level.get_node("Story")
	var total_time = Time.get_ticks_msec() - timer_start
	
	if total_time < 0:
		next_story.speedrun_data.text = ""
	else:
		next_story.speedrun_data.text = "[center]You have finished the game in %s[/center]" % beautify_time(total_time)

func kill_old_level():
	await get_tree().process_frame
	root.queue_free()

func beautify_time(time: int) -> String:
	var seconds = beautify_number((time / 1000) % 60)
	var minutes = beautify_number((time / 1000 / 60) % 60)
	var hours = beautify_number(time / 1000 / 60 / 60)
	return "%s:%s:%s" % [hours, minutes, seconds]

func beautify_number(num: int) -> String:
	if num < 10:
		return "0%d" % num
	else:
		return "%d" % num

func set_state_all_children(node: Node, state: bool):
	for child in node.get_children(true):
		child.set_process(state)
		child.set_physics_process(state)
		child.set_process_input(state)
		set_state_all_children(child, state)

func _on_level_enter(idx):
	for i in 4:
		if idx != i + 1:
			set_state_all_children(levels[i], false)

func _on_level_exit(idx):
	for i in 4:
		if idx != i + 1:
			set_state_all_children(levels[i], true)

