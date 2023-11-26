extends RayCast3D
class_name Laser

@onready var beam_mesh: MeshInstance3D = $BeamMesh
@onready var particles = $EndParticles
@onready var emit_audio = $EmitAudioStream
@onready var collision_audio = $CollisionAudioStream
var laser_target: Object = null
var laser_material: BaseMaterial3D
var color: Color = Color(1, 1, 1)

func _ready():
	var material = beam_mesh.get_surface_override_material(0) as BaseMaterial3D
	laser_material = material.duplicate(true)
	beam_mesh.mesh = beam_mesh.mesh.duplicate()
	beam_mesh.set_surface_override_material(0, laser_material)
	if self.visible:
		self.emit_audio.play()
		self.collision_audio.stop()

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
		collider.enable_laser(color)

func fire_at_cast_point(cast_point: float):
	beam_mesh.mesh.height = abs(cast_point)
	beam_mesh.position.z = cast_point / 2
	particles.position.z = cast_point
	collision_audio.position.z = cast_point

func unmount_target():
	if laser_target and laser_target != null:
		laser_target.disable_laser()
		laser_target = null

func disable():
	unmount_target()
	self.visible = false;
	self.emit_audio.stop()
	self.collision_audio.stop()
	
func enable():
	self.emit_audio.play()
	self.collision_audio.play()
	self.visible = true;

func set_color(color: Color):
	laser_material.emission = color
	laser_material.albedo_color = color
	self.color = color
	pass
