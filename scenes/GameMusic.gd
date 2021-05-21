extends AudioStreamPlayer

onready var events = get_tree().get_nodes_in_group('events')[0]

func _ready():
	var _connected = events.connect("set_music_volume", self, "set_music_volume")

func set_music_volume(new_volume):
	print('setting_volume')
	print(new_volume)
	volume_db = clamp(new_volume, -80, 0)
