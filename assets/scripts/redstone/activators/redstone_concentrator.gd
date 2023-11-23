extends RedstoneAbstractActivator

@export var mesh: MeshInstance3D

var activators: Array[RedstoneAbstractActivator] = []
var receiver_children: Array[RedstoneBase] = []
var material: ShaderMaterial

func _ready():
	super._ready()
	for i in children:
		if i is RedstoneAbstractActivator:
			activators.push_back(i)
		else:
			receiver_children.push_back(i)

func _process(_delta):
	if is_activates:
		return
	for i in activators:
		if not i.is_activates:
			return
	for i in activators:
		i.freeze_activation()
	is_activates = true
	material.set_shader_parameter("emission_k", 1.0)


func set_redstone_material(m: Material):
	self.material = m.duplicate(true)
	mesh.set_surface_override_material(0, self.material)
	super.set_redstone_material(self.material)
