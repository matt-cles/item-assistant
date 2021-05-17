extends MeshInstance

export var speed:float = 1.0
var reposition_x_amount = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibilityNotifier.connect("screen_exited", self, 'reposition')

func _process(delta):
	translation.x -= delta * speed
	
func reposition():
	translation.x += reposition_x_amount
