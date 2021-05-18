extends Spatial

export var cycle_speed = 0.1

func _process(delta):
	rotation.z += cycle_speed * delta
	$"sun-1".rotation.z -= cycle_speed * delta
	$"moon-1".rotation.z -= cycle_speed * delta
