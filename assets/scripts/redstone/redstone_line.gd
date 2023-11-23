extends RedstoneBase
class_name RedstoneLine


var children: Array[RedstoneBase] = []

func _ready():
	for c in self.get_children():
		if c is RedstoneBase:
			children.push_back(c)

func set_redstone_material(material: Material):
	for c in children:
		c.set_redstone_material(material)
