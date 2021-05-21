extends Control

onready var events = get_tree().get_nodes_in_group('events')[0]
onready var settings:Settings = get_tree().get_nodes_in_group('settings')[0]
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartMenu.visible = true
	$PauseMenu.visible = get_tree().paused
	$SettingsMenu.visible = false
	$SettingsMenu/VolumeControl/VolumeSlider.min_value = settings.min_volume
	$SettingsMenu/VolumeControl/VolumeSlider.max_value = settings.max_volume
	$SettingsMenu/VolumeControl/VolumeSlider.value = settings.default_volume

func _process(delta):
	if game_started:
		if Input.is_action_just_pressed("ui_cancel"):
			var currently_paused = get_tree().paused
			get_tree().paused = not currently_paused
			$PauseMenu.visible = not currently_paused

func _on_StartGame_pressed():
	game_started = true
	$StartMenu.visible = false
	events.emit_signal('start_game')

func _on_Exit_pressed():
	get_tree().quit()

func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Options_pressed():
	$StartMenu.visible = false
	$SettingsMenu.visible = true

func _on_BackToStartMenu_pressed():
	$StartMenu.visible = true
	$SettingsMenu.visible = false

func _on_VolumeSlider_value_changed(value):
	events.emit_signal("set_music_volume", value)
