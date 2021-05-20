extends Camera

export var use_pixels = true
onready var viewport = get_viewport()

func _ready():
	var _connected = get_tree().get_root().connect("size_changed", self, "_on_resize")
	pixelize()

func _on_resize():
	pixelize()

func pixelize():
	if use_pixels:
		viewport.size = Vector2(300, 200)
