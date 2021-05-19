extends Control

onready var hero = get_tree().get_nodes_in_group('hero')[0]
onready var hero_health_bar = get_node("Hero/Health/HealthBar")
onready var hero_mana_bar = get_node("Hero/Mana/ManaBar")
onready var hero_stamina_bar = get_node("Hero/Stamina/StaminaBar")

func _ready():
	var _connected = hero.connect("health_changed", self, "update_hero_health_bar")
	_connected = hero.connect("mana_changed", self, "update_hero_mana_bar")
	_connected = hero.connect("stamina_changed", self, "update_hero_stamina_bar")
	hero_health_bar.value = hero.health
	hero_mana_bar.value = hero.mana
	hero_stamina_bar.value = hero.stamina

func update_hero_health_bar(new_health):
	hero_health_bar.value = new_health
	
func update_hero_mana_bar(new_mana):
	hero_mana_bar.value = new_mana
	
func update_hero_stamina_bar(new_stamina):
	hero_stamina_bar.value = new_stamina
