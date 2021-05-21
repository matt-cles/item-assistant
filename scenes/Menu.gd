extends Control

onready var events = get_tree().get_nodes_in_group('events')[0]
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartMenu.visible = true
	$PauseMenu.visible = get_tree().paused

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
	$PauseMenu.visible = false
