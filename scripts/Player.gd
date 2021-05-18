extends Spatial

onready var events:Node = get_tree().get_nodes_in_group("events")[0]

enum PLAYER_MODEL {RANDOM, MALE, FEMALE}

export (PLAYER_MODEL) var character_model = PLAYER_MODEL.RANDOM
var items_in_inventory
var current_item

func _ready():
	$pivot/MaleCharacter.visible = character_model == PLAYER_MODEL.MALE
	$pivot/FemaleCharacter.visible = character_model == PLAYER_MODEL.FEMALE
	if character_model == PLAYER_MODEL.RANDOM:
		var random_selection:bool = randi() % 2
		$pivot/MaleCharacter.visible = random_selection
		$pivot/FemaleCharacter.visible = not random_selection
	var _connected = events.connect('stop_moving', self, 'stop_walking')
	_connected = events.connect('start_moving', self, 'start_walking')
	$AnimationPlayer.play("walk")
	$AnimationPlayer.playback_speed = 1.5
	items_in_inventory = get_tree().get_nodes_in_group("item")
	current_item = 0
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
	for child in $pivot/WeaponSlot1.get_children():
		if child.is_in_group("item"):
			$pivot/WeaponSlot1.remove_child(child)
	$pivot/WeaponSlot1.add_child(weapon)
	
func give_current_item_to_hero():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		events.emit_signal('stop_moving')

	if Input.is_action_just_pressed("ui_up"):
		events.emit_signal("start_moving")

	if Input.is_action_just_pressed("ui_right"):
		next_weapon()

	if Input.is_action_just_pressed("ui_left"):
		prev_weapon()

func start_walking():
	$AnimationPlayer.play("walk")
	
func stop_walking():
	$AnimationPlayer.play("still")
