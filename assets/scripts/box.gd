extends RigidBody3D
class_name Box

@export var box_name: String = "Foo" 

@onready var shape = $CollisionShape3D

func _ready():
	enable_collision()

func disable_collision():
	shape.disabled = true
	freeze = true

func enable_collision():
	shape.disabled = false
	freeze = false
