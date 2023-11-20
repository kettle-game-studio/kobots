extends RobotController
class_name RobotLaser

@onready var laser = $Laser


func enable_laser():
	laser.enable()
	
	
func disable_laser():
	laser.disable()
