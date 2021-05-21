extends MeshInstance

var speed:float = 0
var reposition_x_amount = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var _connected = $VisibilityNotifier.connect("screen_exited", self, 'reposition')
	set_speed()

func set_speed():
	speed = 0.1 - randf() / 10

func _process(delta):
	translation.x -= delta * speed

func reposition():
	translation.x += reposition_x_amount
	set_speed()
