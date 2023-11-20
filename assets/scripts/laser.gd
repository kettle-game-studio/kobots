@tool
extends RayCast3D
class_name Laser

@onready var beam_mesh = $BeamMesh
@onready var particles = $EndParticles 
var robot: RobotLaser

func _ready():
	beam_mesh.mesh = beam_mesh.mesh.duplicate()
	robot = null
	

func _process(delta):
	if !self.visible:
		return
		
	var cast_point 
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = abs(cast_point.z)
		beam_mesh.position.z = cast_point.z/2
		
		particles.position.z = cast_point.z
		
		var collider = self.get_collider()
		if collider is RobotLaser:
			if collider != robot:
				robot = collider
				robot.disable_laser()
			if not Engine.is_editor_hint():
				collider.enable_laser()
			print("tut nado prokinut estcho odin laser")
		elif robot:
			robot.disable_laser()
			robot = null
	elif robot:
		robot.disable_laser()
		robot = null

func disable():
	self.visible = false;
	
func enable():
	self.visible = true;
	
