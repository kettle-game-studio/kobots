extends Node

@export var fps_text: RichTextLabel

func _process(delta):
	fps_text.text = "[right]%d fps[/right]" % Performance.get_monitor(Performance.TIME_FPS)
