extends Spatial

onready var events:Node = get_tree().get_nodes_in_group("events")[0]
var walking = true

func _ready():
	var _connected = events.connect('stop_moving', self, 'stop_walking')
	_connected = events.connect('start_moving', self, 'start_walking')
	$AnimationPlayer.play("walk")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer, "animation_finished")
		var next = "walk" if walking else "still"
		$AnimationPlayer.play(next)

func start_walking():
	walking = true
	$AnimationPlayer.play("walk")
	
func stop_walking():
	walking = false
	$AnimationPlayer.play("still")
