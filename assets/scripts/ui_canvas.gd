extends CanvasLayer
class_name UICanvas

@export var text_label: RichTextLabel

func _ready():
	clear_text()

func enable():
	self.visible = true

func disable():
	self.visible = false

func set_text(text: String):
	text_label.text = "[center]%s[/center]" % text

func clear_text():
	text_label.text = ""
