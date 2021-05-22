extends Control

onready var events = get_tree().get_nodes_in_group('events')[0]
onready var settings:Settings = get_tree().get_nodes_in_group('settings')[0]
onready var sfx = get_tree().get_nodes_in_group('player')[0].get_node("SFX")
var game_started = false
var hero_dead = false
var allow_preview_sfx = false

func _ready():
	$StartMenu.visible = true
	$PauseMenu.visible = get_tree().paused
	$DeathMenu.visible = false
	$SettingsMenu.visible = false
	var _connected = events.connect("hero_dead", self, 'show_death_menu')
	$SettingsMenu/PlayerModelControl/PlayerModel.add_item('Random', settings.PLAYER_MODEL.RANDOM)
	$SettingsMenu/PlayerModelControl/PlayerModel.add_item('Male', settings.PLAYER_MODEL.MALE)
	$SettingsMenu/PlayerModelControl/PlayerModel.add_item('Female', settings.PLAYER_MODEL.FEMALE)

func get_settings_values():
	allow_preview_sfx = false
	$SettingsMenu/MusicVolumeControl/VolumeSlider.min_value = settings.min_volume
	$SettingsMenu/MusicVolumeControl/VolumeSlider.max_value = settings.max_volume
	$SettingsMenu/MusicVolumeControl/VolumeSlider.value = settings.default_music_volume
	$SettingsMenu/SFXVolumeControl/VolumeSlider.min_value = settings.min_volume
	$SettingsMenu/SFXVolumeControl/VolumeSlider.max_value = settings.max_volume
	$SettingsMenu/SFXVolumeControl/VolumeSlider.value = settings.default_sfx_volume
	$SettingsMenu/DifficultyControl/DifficultySlider.value = settings.difficulty_increment
	$SettingsMenu/DifficultyControl/DifficultySlider.min_value = settings.min_difficulty
	$SettingsMenu/DifficultyControl/DifficultySlider.max_value = settings.max_difficulty
	$SettingsMenu/PlayerModelControl/PlayerModel.selected = settings.character_model

func _process(_delta):
	if game_started and not hero_dead:
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
	var _reloaded = get_tree().reload_current_scene()

func _on_Options_pressed():
	get_settings_values()
	$StartMenu.visible = false
	$SettingsMenu.visible = true

func _on_BackToStartMenu_pressed():
	$StartMenu.visible = true
	$SettingsMenu.visible = false

func _on_MusicVolumeSlider_value_changed(value):
	events.emit_signal("set_music_volume", value)

func _on_SFXVolumeSlider_value_changed(value):
	events.emit_signal("set_sfx_volume", value)
	if allow_preview_sfx:
		var sounds = sfx.get_children()
		var random_sfx = sounds[randi() % len(sounds)]
		random_sfx.play()

func _on_DifficultySlider_value_changed(value):
	events.emit_signal("set_difficulty", value)

func _on_PlayerModel_item_selected(index):
	events.emit_signal("set_player_model", index)

func show_death_menu():
	hero_dead = true
	$DeathMenu.visible = true

func _on_VolumeSlider_mouse_entered():
	allow_preview_sfx = true
