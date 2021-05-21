extends AudioStreamPlayer

onready var events = get_tree().get_nodes_in_group('events')[0]
onready var settings = get_tree().get_nodes_in_group('settings')[0]

func _ready():
	var _connected = events.connect("set_music_volume", self, "set_music_volume")

func set_music_volume(new_volume):
	volume_db = clamp(new_volume, settings.min_volume, settings.max_volume)
