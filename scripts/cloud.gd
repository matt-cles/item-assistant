extends MeshInstance

export var speed:float = .1
var reposition_x_amount = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var _connected = $VisibilityNotifier.connect("screen_exited", self, 'reposition')
	speed -= randf() / 10

func _process(delta):
	translation.x -= delta * speed
	
func reposition():
	translation.x += reposition_x_amount
