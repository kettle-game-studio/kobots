extends RayCast3D
class_name Laser

@onready var beam_mesh = $BeamMesh
@onready var particles = $EndParticles
var laser_target: Object = null


func _ready():
	beam_mesh.mesh = beam_mesh.mesh.duplicate()

func _process(delta):
	if !self.visible:
		return
	
	force_raycast_update()
	
	if !is_colliding():
		fire_at_cast_point(-1000)
		unmount_target()
		return
		
	var cast_point = to_local(get_collision_point()).z
	fire_at_cast_point(cast_point)
	
	var collider = self.get_collider()
	if !collider.has_method("enable_laser"):
		unmount_target()
		return
	
	if collider != laser_target:
		unmount_target()
		laser_target = collider
		collider.enable_laser()

func fire_at_cast_point(cast_point: float):
	beam_mesh.mesh.height = abs(cast_point)
	beam_mesh.position.z = cast_point / 2
	particles.position.z = cast_point

func unmount_target():
	if laser_target:
		laser_target.disable_laser()
		laser_target = null

func disable():
	unmount_target()
	self.visible = false;
	
func enable():
	self.visible = true;
	
