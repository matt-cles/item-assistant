extends Spatial

signal health_changed
signal mana_changed
signal stamina_changed

onready var events:Node = get_tree().get_nodes_in_group("events")[0]
onready var weapon_slot = get_node("pivot/RightHand/WeaponSlot")

export var max_health:float = 100
export var max_mana:float = 100
export var max_stamina:float = 100

var walking = true
var health:float = max_health
var mana:float = 0
var stamina:float = 0

func _ready():
	var _connected = events.connect('stop_moving', self, 'stop_walking')
	_connected = events.connect('start_moving', self, 'start_walking')
	_connected = events.connect('hero_turn', self, 'attack')
	_connected = events.connect('damage_hero', self, 'take_damage')
	$AnimationPlayer.play("walk")
	modify_health(max_health)
	modify_mana(max_mana/2)
	modify_stamina(max_stamina/2)

func _process(delta):
	var current_item:Item = get_weapon()
	if current_item:
		match current_item.restore_type:
			Item.RESTORE_TYPES.HEALTH:
				modify_health(current_item.restore_amount * delta)
			Item.RESTORE_TYPES.MANA:
				modify_mana(current_item.restore_amount * delta)
			Item.RESTORE_TYPES.STAMINA:
				modify_stamina(current_item.restore_amount * delta)

func get_weapon():
	var weapons = weapon_slot.get_children()
	if weapons:
		return weapons[0]
	return null

func take_damage(damage):
	modify_health(-damage)

func modify_health(amount):
	health = clamp(health+amount, 0.0, max_health)
	emit_signal("health_changed", health)

func modify_mana(amount):
	mana = clamp(mana+amount, 0.0, max_mana)
	emit_signal("mana_changed", mana)

func modify_stamina(amount):
	stamina = clamp(stamina+amount, 0.0, max_stamina)
	emit_signal("stamina_changed", stamina)

func start_walking():
	walking = true
	$AnimationPlayer.play("walk")

func stop_walking():
	walking = false
	$AnimationPlayer.play("still")
	attack()
	
func attack():
	$AnimationPlayer.play("attack")
	yield($AnimationPlayer, "animation_finished")
	var current_item:Item = get_weapon()
	if current_item:
		events.emit_signal("damage_enemy", current_item.damage)
	events.emit_signal("enemy_turn")
	
