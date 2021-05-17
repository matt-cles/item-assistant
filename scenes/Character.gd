extends Spatial

#var item_scene:PackedScene = preload("res://scenes/Items.tscn")
#var items = item_scene.instance()

func _ready():
	$AnimationPlayer.play("walk")
	get_random_weapon()

func get_random_weapon():
	var weapons = get_tree().get_nodes_in_group("weapon")
	var weapon = weapons[randi() % len(weapons)]
	weapon = weapon.duplicate()
	weapon.translation = Vector3.ZERO
	weapon.rotation_degrees.y = 90
	for child in $pivot/WeaponSlot1.get_children():
		if child.is_in_group("item"):
			$pivot/WeaponSlot1.remove_child(child)
	$pivot/WeaponSlot1.add_child(weapon)
	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("attack")
		$AnimationPlayer.animation_set_next("attack", "walk")
	if Input.is_action_just_pressed("ui_right"):
		get_random_weapon()
