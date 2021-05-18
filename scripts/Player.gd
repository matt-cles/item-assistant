extends Spatial

onready var events:Node = get_tree().get_nodes_in_group("events")[0]
onready var hero:Node = get_tree().get_nodes_in_group("hero")[0]

enum PLAYER_MODEL {RANDOM, MALE, FEMALE}

export (PLAYER_MODEL) var character_model = PLAYER_MODEL.RANDOM
var items_in_inventory
var current_item

func _ready():
	# Select the character model
	$pivot/MaleCharacter.visible = character_model == PLAYER_MODEL.MALE
	$pivot/FemaleCharacter.visible = character_model == PLAYER_MODEL.FEMALE
	if character_model == PLAYER_MODEL.RANDOM:
		var random_selection:bool = randi() % 2
		$pivot/MaleCharacter.visible = random_selection
		$pivot/FemaleCharacter.visible = not random_selection

	# Connect events
	var _connected = events.connect('stop_moving', self, 'stop_walking')
	_connected = events.connect('start_moving', self, 'start_walking')

	# Start walk animation
	$AnimationPlayer.play("walk")
	$AnimationPlayer.playback_speed = 1.5

	# Initialize the inventory
	items_in_inventory = get_tree().get_nodes_in_group("item")
	current_item = 0
	hold_current_item()
	give_current_item_to_hero()
	current_item = randi() % len(items_in_inventory)
	hold_current_item()
	
func next_weapon():
	current_item = (current_item + 1) % len(items_in_inventory)
	hold_current_item()
	
func prev_weapon():
	current_item = (current_item - 1) % len(items_in_inventory)
	hold_current_item()
	
func hold_current_item():
	var weapon = items_in_inventory[current_item]
	weapon = weapon.duplicate()
	weapon.translation = Vector3.ZERO
	weapon.rotation_degrees.y = 90
	for child in $pivot/RightHand/WeaponSlot.get_children():
		if child.is_in_group("item"):
			$pivot/RightHand/WeaponSlot.remove_child(child)
	$pivot/RightHand/WeaponSlot.add_child(weapon)
	
func give_current_item_to_hero():
	var hero_weapon_slot:Spatial = hero.get_node("pivot/RightHand/WeaponSlot")
	var hero_weapons = hero_weapon_slot.get_children()
	var current_hero_weapon = null
	for weapon in hero_weapons:
		current_hero_weapon = weapon
		hero_weapon_slot.remove_child(weapon)
	var player_weapon_slot = $pivot/RightHand/WeaponSlot
	var player_weapon = player_weapon_slot.get_children()[0]
	player_weapon_slot.remove_child(player_weapon)
	hero_weapon_slot.add_child(player_weapon)
	if current_hero_weapon:
		player_weapon_slot.add_child(current_hero_weapon)
		items_in_inventory[current_item] = current_hero_weapon.duplicate()
	else:
		items_in_inventory.remove(current_item)


func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		events.emit_signal('stop_moving')

	if Input.is_action_just_pressed("ui_up"):
		events.emit_signal("start_moving")

	if Input.is_action_just_pressed("ui_right"):
		next_weapon()

	if Input.is_action_just_pressed("ui_left"):
		prev_weapon()

	if Input.is_action_just_pressed("ui_accept"):
		give_current_item_to_hero()

func start_walking():
	$AnimationPlayer.play("walk")

func stop_walking():
	$AnimationPlayer.play("still")
