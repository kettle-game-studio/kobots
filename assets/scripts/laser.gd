@tool
extends RayCast3D

@onready var beam_mesh = $BeamMesh
@onready var particles = $EndParticles 

# Called when the node enters the scene tree for the first time.
func _ready():
	beam_mesh.mesh = beam_mesh.mesh.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cast_point 
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		print("cast_point ", cast_point)
		
		beam_mesh.mesh.height = abs(cast_point.z)
		beam_mesh.position.z = cast_point.z/2
		
		particles.position.z = cast_point.z
