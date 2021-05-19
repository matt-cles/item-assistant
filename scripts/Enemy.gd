extends Spatial

onready var events:Node = get_tree().get_nodes_in_group('events')[0]

var moving = true
var move_speed = 2

func _ready():
	print($Area)
	var _connected = $Area.connect("body_entered", self, 'combat_start')
	print(_connected)
	_connected = events.connect("start_moving", self, "start_moving")
	print(_connected)
	_connected = events.connect("stop_moving", self, "stop_moving")
	print(_connected)
	$AnimationPlayer.play("walk")

func combat_start(body:Node):
	print(body)
	print('combat time')
	events.emit_signal('stop_moving')

func _process(delta):
	translation.x += move_speed * delta * float(moving)

func start_moving():
	$AnimationPlayer.play("walk")
	moving = true


func stop_moving():
	$AnimationPlayer.play("still")
	moving = false
