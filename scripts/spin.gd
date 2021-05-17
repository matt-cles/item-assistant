extends Spatial

export var rotation_speed = 1

func _process(delta):
	rotate(Vector3.UP, rotation_speed * delta)
