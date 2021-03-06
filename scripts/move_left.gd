extends Spatial

onready var events:Node = get_tree().get_nodes_in_group("events")[0]
var movement_speed = 1
var moving = true

func _ready():
	var _connected = $VisibilityNotifier.connect("screen_exited", self, "reposition")
	_connected = events.connect('stop_moving', self, 'stop_moving')
	_connected = events.connect('start_moving', self, 'start_moving')
	show_one_mesh()
	
func show_one_mesh():
	var meshes = $TreeMeshes.get_children()
	for mesh in meshes:
		mesh.visible = false
	var selected_mesh = meshes[randi() % len(meshes)]
	selected_mesh.visible = true

func _process(delta):
	if moving:
		var movement = (Vector3.RIGHT * delta * movement_speed).rotated(Vector3.UP, rotation.y)
		translation += movement

func reposition():
	var spawn_points = get_tree().get_nodes_in_group('tree_spawn_point')
	if spawn_points:
		var spawn_point = spawn_points[randi() % len(spawn_points)]
		translation = spawn_point.translation
		show_one_mesh()

func start_moving():
	moving = true

func stop_moving():
	moving = false
