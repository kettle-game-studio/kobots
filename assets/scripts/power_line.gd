extends Node3D

@export var powered_color: Color
@export var unpowered_color: Color  

var children: Array[Node]
var material: StandardMaterial3D

func _ready():
	children = self.get_children()
	if children.size() > 0:
		material = (children[0] as CSGMesh3D).material.duplicate()
	for child in children:
		(child as CSGMesh3D).material = material
	material.albedo_color = unpowered_color
	
func on_powered(_o: Object):
	material.albedo_color = powered_color

func on_unpowered(_o: Object):
	material.albedo_color = unpowered_color
