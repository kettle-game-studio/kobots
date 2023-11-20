extends RobotController
class_name RobotLaser

@onready var laser = $Laser

var count = 0

func _ready():
	laser.disable()

func enable_laser():
	count += 1
	laser.enable()
	
func disable_laser():
	count -= 1
	if count <= 0:
		laser.disable()
