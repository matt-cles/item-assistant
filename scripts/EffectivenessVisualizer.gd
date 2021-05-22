extends MeshInstance

export var scroll_speed = 1

func _process(delta):
	translation.y += scroll_speed * delta
