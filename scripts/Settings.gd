extends Node
class_name Settings

const CONFIG_FILE_PATH = "user://settings.cfg"

onready var events:Node = get_tree().get_nodes_in_group('events')[0]

enum PLAYER_MODEL {RANDOM, MALE, FEMALE}

export (PLAYER_MODEL) var character_model

export (float, -80, 10) var min_volume = -80
export (float, -80, 10) var max_volume = 2
export (float, -80, 10) var default_music_volume
export (float, -80, 10) var default_sfx_volume

export (float, 0.1, 1) var min_difficulty = 0.1
export (float, 0.1, 1) var max_difficulty = 1.0
export (float, 0.1, 1) var difficulty_increment

var config_file = null

func _ready():
	# Connect updaters
	var _connected = events.connect("set_player_model", self, "set_player_model")
	_connected = events.connect("set_difficulty", self, "set_difficulty")
	_connected = events.connect("set_music_volume", self, "set_music_volume")
	_connected = events.connect("set_sfx_volume", self, "set_sfx_volume")

	# Try to load from conf file
	config_file = ConfigFile.new()
	var error_loading_file = config_file.load(CONFIG_FILE_PATH)
	if error_loading_file == OK:
		print("Loading Config File")
	elif error_loading_file == ERR_FILE_NOT_FOUND:
		print("Creating new config file at path")
		config_file.save(CONFIG_FILE_PATH)
	else:
		print("Unable to load config... Using project defaults")

	# Set settings vars to values in config, if they exist
	events.emit_signal("set_player_model", config_file.get_value('player', 'character_model', PLAYER_MODEL.RANDOM))
	events.emit_signal("set_music_volume", config_file.get_value('volume', 'music_volume', -10))
	events.emit_signal("set_sfx_volume", config_file.get_value('volume', 'sfx_volume', -10))
	events.emit_signal("set_difficulty", config_file.get_value('difficulty', 'increment', .5))

func set_player_model(index):
	character_model = index
	config_file.set_value('player', 'character_model', index)
	config_file.save(CONFIG_FILE_PATH)

func set_difficulty(difficulty):
	difficulty_increment = difficulty
	config_file.set_value('difficulty', 'increment', difficulty)
	config_file.save(CONFIG_FILE_PATH)

func set_music_volume(level):
	default_music_volume = level
	config_file.set_value('volume', 'music_volume', level)
	config_file.save(CONFIG_FILE_PATH)

func set_sfx_volume(level):
	default_sfx_volume = level
	config_file.set_value('volume', 'sfx_volume', level)
	config_file.save(CONFIG_FILE_PATH)
