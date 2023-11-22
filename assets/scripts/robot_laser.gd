extends RobotController
class_name RobotLaser

@onready var laser = $Laser
@onready var crab: Crab = $Crab

var count = 0

func _ready():
	laser.disable()

func enable_laser():
	count += 1
	laser.enable()
	crab.set_enable_laser(true)
	
func disable_laser():
	count -= 1
	if count <= 0:
		laser.disable()
		crab.set_enable_laser(false)
