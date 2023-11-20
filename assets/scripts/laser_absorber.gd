extends StaticBody3D
class_name LaserAbsorber

signal pressed(LaserAbsorber)
signal unpressed(LaserAbsorber)

func enable_laser():
	pressed.emit(self)

func disable_laser():
	unpressed.emit(self)
