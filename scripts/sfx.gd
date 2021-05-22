extends AudioStreamPlayer

onready var events:Node = get_tree().get_nodes_in_group('events')[0]
onready var settings:Settings = get_tree().get_nodes_in_group('settings')[0]

export (float, 0.0, 1.0) var balancer = 1.0

func _ready():
	var _connected = events.connect('set_sfx_volume', self, 'set_sfx_volume')
	volume_db = clamp(settings.default_music_volume, settings.min_volume, settings.max_volume)

func set_sfx_volume(vol):
	var balance_amount = -80.0 * (1 - balancer)
	volume_db = clamp(vol + balance_amount, settings.min_volume, settings.max_volume)
	print(volume_db)
