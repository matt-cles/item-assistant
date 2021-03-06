extends Spatial

onready var settings:Settings = get_tree().get_nodes_in_group("settings")[0]
onready var events:Node = get_tree().get_nodes_in_group('events')[0]
onready var spawn_point = get_tree().get_nodes_in_group('enemy_spawn_point')[0]
onready var weapons = get_tree().get_nodes_in_group('weapon')

onready var effective_texture = load("res://assets/effectiveness/Effective.tres")
onready var ineffective_texture = load("res://assets/effectiveness/Ineffective.tres")
onready var critical_texture = load("res://assets/effectiveness/Critical.tres")
onready var resisted_texture = load("res://assets/effectiveness/Resisted.tres")

var moving = false
var dead = false
var hero_dead = false
var move_speed = 2
var level = 1.0
var damage = 0.0
var damage_ratio:float
var health:float
var weapon:Item

var type:int
# Item damage types are: Fire, Ice, Heavy, Slash, Pierce, Stealth
var types = [ 
	{
		# Green Human
		'resisted': [Item.DAMAGE_TYPES.SLASH],
		'ineffective': [Item.DAMAGE_TYPES.ICE, Item.DAMAGE_TYPES.STEALTH],
		'effective': [Item.DAMAGE_TYPES.PIERCE, Item.DAMAGE_TYPES.HEAVY],
		'critical' : [Item.DAMAGE_TYPES.FIRE],
	}, {
		# Red Human
		'resisted': [Item.DAMAGE_TYPES.PIERCE],
		'ineffective': [Item.DAMAGE_TYPES.FIRE, Item.DAMAGE_TYPES.SLASH],
		'effective': [Item.DAMAGE_TYPES.ICE, Item.DAMAGE_TYPES.STEALTH],
		'critical' : [Item.DAMAGE_TYPES.HEAVY],
	}, {
		# Blue Human
		'resisted': [Item.DAMAGE_TYPES.HEAVY],
		'ineffective': [Item.DAMAGE_TYPES.ICE, Item.DAMAGE_TYPES.PIERCE],
		'effective': [Item.DAMAGE_TYPES.FIRE, Item.DAMAGE_TYPES.SLASH],
		'critical' : [Item.DAMAGE_TYPES.STEALTH],
	}, {
		# Orange Tall Guy
		'resisted': [Item.DAMAGE_TYPES.STEALTH, Item.DAMAGE_TYPES.SLASH],
		'ineffective': [Item.DAMAGE_TYPES.PIERCE, Item.DAMAGE_TYPES.HEAVY],
		'effective': [],
		'critical' : [Item.DAMAGE_TYPES.ICE, Item.DAMAGE_TYPES.FIRE],
	}, {
		# goblin-1
		'resisted': [Item.DAMAGE_TYPES.ICE, Item.DAMAGE_TYPES.FIRE],
		'ineffective': [Item.DAMAGE_TYPES.HEAVY],
		'effective': [Item.DAMAGE_TYPES.PIERCE, Item.DAMAGE_TYPES.STEALTH],
		'critical' : [Item.DAMAGE_TYPES.SLASH],
	}, {
		# goblin-2
		'resisted': [Item.DAMAGE_TYPES.ICE, Item.DAMAGE_TYPES.FIRE],
		'ineffective': [Item.DAMAGE_TYPES.HEAVY],
		'effective': [Item.DAMAGE_TYPES.STEALTH, Item.DAMAGE_TYPES.SLASH],
		'critical' : [Item.DAMAGE_TYPES.PIERCE],
	},
]

func _ready():
	var _connected = $Area.connect("area_entered", self, 'initiate_combat')
	_connected = events.connect("start_moving", self, "start_moving")
	_connected = events.connect("start_game", self, "start_moving")
	_connected = events.connect("stop_moving", self, "stop_moving")
	_connected = events.connect("enemy_turn", self, "attack")
	_connected = events.connect("damage_enemy", self, "take_damage")
	_connected = events.connect("hero_dead", self, "hero_death")
	initialize()

func initialize():
	# Get a random enemy type
	type = randi() % len(types)
	for mesh in $pivot/Meshes.get_children():
		mesh.visible = false
	for mesh in $pivot/RightHand/HandMeshes.get_children():
		mesh.visible = false
	$pivot/Meshes.get_child(type).visible = true
	$pivot/RightHand/HandMeshes.get_child(type).visible = true

	# Reset enemy vars
	move_speed = 2
	dead = false
	health = 90 + 10 * level
	$StatusBars/HealthBarSprite/Viewport/HealthBar.max_value = health
	$StatusBars/HealthBarSprite/Viewport/HealthBar.value = health
	$StatusBars/HealthBarSprite.visible = true
	damage = 10 * settings.difficulty_increment * level
	translation = Vector3.ZERO
	$AnimationPlayer.play("walk")

	# Pick a random weapon
	weapon = weapons[randi() % len(weapons)].duplicate()
	# Prevent from getting a duplicated weapon in the player inventory..
	weapon.remove_from_group('item')
	weapon.remove_from_group('weapon')
	weapon.rotate_y(90)
	weapon.translation = Vector3.ZERO
	var weapon_slot = $pivot/RightHand/WeaponSlot
	for old_weapon in weapon_slot.get_children():
		weapon_slot.remove_child(old_weapon)
		old_weapon.queue_free()
	weapon_slot.add_child(weapon)

	# Hide effectivness visualizer
	$StatusBars/EffectivenessSpawn/EffectivenessVisualizer.visible = false

func _process(delta):
	translation.x += move_speed * delta * float(moving)

func initiate_combat(_body:Node):
	events.emit_signal("stop_moving")

func attack():
	if not moving and not dead and not hero_dead:
		$AnimationPlayer.play("attack")
		yield($AnimationPlayer, "animation_finished")
		events.emit_signal("damage_hero", damage)
		events.emit_signal("hero_turn")

func display_effectiveness(texture):
	$StatusBars/EffectivenessSpawn/EffectivenessVisualizer.mesh.surface_set_material(0, texture)
	$StatusBars/EffectivenessSpawn/EffectivenessVisualizer.translation = $StatusBars/EffectivenessSpawn.translation
	$StatusBars/EffectivenessSpawn/EffectivenessVisualizer.visible = true

func take_damage(damage_given, damage_type=Item.DAMAGE_TYPES.NONE):
	if damage_type in types[type].resisted:
		damage_given *= .05
		display_effectiveness(resisted_texture)
	elif damage_type in types[type].ineffective:
		damage_given *= .5
		display_effectiveness(ineffective_texture)
	elif damage_type in types[type].effective:
		damage_given *= 3
		display_effectiveness(effective_texture)
	elif damage_type in types[type].critical:
		damage_given *= 8
		display_effectiveness(critical_texture)
	health -= damage_given
	$StatusBars/HealthBarSprite/Viewport/HealthBar.value = health
	if health <= 0:
		$AnimationPlayer.play("die")
		events.emit_signal("enemy_defeated")
		dead = true
		move_speed = 1
		events.emit_signal("start_moving")
		$StatusBars/HealthBarSprite.visible = false

func start_moving():
	if not dead:
		$AnimationPlayer.play("walk")
	moving = true

func stop_moving():
	$AnimationPlayer.play("still")
	moving = false

func increase_difficulty():
	level += settings.difficulty_increment

func hero_death():
	hero_dead = true

func _on_VisibilityNotifier_screen_exited():
	increase_difficulty()
	initialize()
