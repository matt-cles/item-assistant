extends Node
class_name Settings

onready var events = get_tree().get_nodes_in_group('events')[0]

enum PLAYER_MODEL {RANDOM, MALE, FEMALE}

export (PLAYER_MODEL) var character_model = PLAYER_MODEL.RANDOM
export (float, .1, 1) var difficulty_increment = .5

export (float, -80, 10) var min_volume = -80
export (float, -80, 10) var max_volume = 2
export (float, -80, 10) var default_music_volume = -22
export (float, -80, 10) var default_sfx_volume = -22

export (float, 0.1, 1) var min_difficulty = 0.1
export (float, 0.1, 1) var max_difficulty = 1.0
export (float, 0.1, 1) var default_difficulty = 0.25

func _ready():
	# Try to load from conf file
	# TODO

	# Connect updaters
	var _connected = events.connect("set_player_model", self, "set_player_model")
	var _connecter = events.connect("set_difficulty", self, "set_difficulty")

func set_player_model(index):
	character_model = index

func set_difficulty(difficulty):
	difficulty_increment = difficulty
