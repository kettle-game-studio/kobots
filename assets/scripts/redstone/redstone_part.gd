extends RedstoneBase

@export var mesh: MeshInstance3D

func set_redstone_material(material: Material):
	if mesh != null:
		mesh.set_surface_override_material(0, material)

