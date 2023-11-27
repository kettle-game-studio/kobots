extends RayCast3D
class_name Laser

@export var beam_meshes: Array[MeshInstance3D]

@onready var beam_root: Node3D = $BeamRoot
@onready var beam_particles: GPUParticles3D = $EndParticles
@onready var particles = $EndParticles
@onready var emit_audio = $EmitAudioStream
@onready var collision_audio = $CollisionAudioStream
var laser_target: Object = null
var laser_material: ShaderMaterial
var partcle_material: StandardMaterial3D
var color: Color = Color(1, 1, 1)

func _ready():
	var material = beam_meshes[0].get_surface_override_material(0) as ShaderMaterial
	laser_material = material.duplicate(true)
	for m in beam_meshes:
		m.mesh = m.mesh.duplicate()
		m.set_surface_override_material(0, laser_material)
	var p_material = beam_particles.material_override as StandardMaterial3D
	partcle_material = p_material.duplicate(true)
	beam_particles.material_override = partcle_material

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
	beam_root.scale.z = abs(cast_point) / 100
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
	laser_material.set_shader_parameter("color", color)
	partcle_material.emission = color
	partcle_material.albedo_color = color
	self.color = color
	pass
