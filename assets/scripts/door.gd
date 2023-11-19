extends Node
class_name Door

@export var door: Node3D
@export var seconds_to_open: float
@export var required_signals: int = 1

@onready var animator = $AnimationPlayer

enum State { CLOSED, OPEN }

var state: State = State.CLOSED
var signals: Dictionary = {}

func open():
	animator.play("opening", -1, seconds_to_open)

func _on_signal_activated(button: ButtonController):
	if state == State.OPEN: return
	
	signals[button] = null
	check_signal_status()

func _on_signal_disactivated(button: ButtonController):
	if state == State.OPEN: return
	
	signals.erase(button)

func check_signal_status():
	print("number of connected buttons ", signals.size(), " required_signals ", required_signals)
	if signals.size() >= required_signals:
		open()
		state = State.OPEN
		for s in signals:
			if s.has_method("freeze_as_activated"):
				s.freeze_as_activated()


