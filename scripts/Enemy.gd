extends Spatial

onready var events:Node = get_tree().get_nodes_in_group('events')[0]

var moving = true
var move_speed = 2
var damage = 10
var health = 100

func _ready():
	var _connected = $Area.connect("area_entered", self, 'initiate_combat')
	_connected = events.connect("start_moving", self, "start_moving")
	_connected = events.connect("stop_moving", self, "stop_moving")
	_connected = events.connect("enemy_turn", self, "attack")
	$AnimationPlayer.play("walk")

func _process(delta):
	translation.x += move_speed * delta * float(moving)

func initiate_combat(body:Node):
	events.emit_signal("stop_moving")

func attack():
	$AnimationPlayer.play("attack")
	yield($AnimationPlayer, "animation_finished")
	events.emit_signal("damage_hero", damage)
	events.emit_signal("hero_turn")
	

func start_moving():
	$AnimationPlayer.play("walk")
	moving = true

func stop_moving():
	$AnimationPlayer.play("still")
	moving = false
