extends Spatial

onready var settings = get_tree().get_nodes_in_group("settings")[0]
onready var events:Node = get_tree().get_nodes_in_group('events')[0]
onready var spawn_point = get_tree().get_nodes_in_group('enemy_spawn_point')[0]
onready var weapons = get_tree().get_nodes_in_group('weapon')

var moving = true
var move_speed = 2
var level = 1.0
var damage_ratio:float
var health:float
var weapon:Item

func _ready():
	var _connected = $Area.connect("area_entered", self, 'initiate_combat')
	_connected = events.connect("start_moving", self, "start_moving")
	_connected = events.connect("stop_moving", self, "stop_moving")
	_connected = events.connect("enemy_turn", self, "attack")
	_connected = events.connect("damage_enemy", self, "take_damage")
	initialize()
	
func initialize():
	health = 100 * level / 10.0
	damage_ratio = level / 10.0
	translation = Vector3.ZERO
	weapon = weapons[randi() % len(weapons)].duplicate()
	weapon.remove_from_group('item')
	weapon.remove_from_group('weapon')
	weapon.rotate_y(90)
	weapon.translation = Vector3.ZERO
	var weapon_slot = $pivot/RightHand/WeaponSlot
	for old_weapon in weapon_slot.get_children():
		weapon_slot.remove_child(old_weapon)
		old_weapon.queue_free()
	weapon_slot.add_child(weapon)
	$AnimationPlayer.play("walk")

func _process(delta):
	translation.x += move_speed * delta * float(moving)

func initiate_combat(_body:Node):
	events.emit_signal("stop_moving")

func attack():
	if not moving:
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer, "animation_finished")
		var damage = weapon.damage * damage_ratio
		events.emit_signal("damage_hero", damage)
		events.emit_signal("hero_turn")
	
func take_damage(damage):
	health = health - damage
	if health <= 0:
		print('dead')
		increase_difficulty()
		initialize()
		events.emit_signal("start_moving")

func start_moving():
	$AnimationPlayer.play("walk")
	moving = true

func stop_moving():
	$AnimationPlayer.play("still")
	moving = false

func increase_difficulty():
	level += settings.difficulty_increment
	print(level)
