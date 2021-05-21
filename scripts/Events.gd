extends Spatial

signal start_game
signal give_hero_item
signal damage_hero
signal damage_enemy
signal hero_turn
signal enemy_turn
signal hero_dead
signal stop_moving
signal start_moving
signal set_music_volume
signal set_sfx_volume
signal set_player_model
signal set_difficulty

func emit_start_game():
	emit_signal("start_game")

func emit_give_hero_item():
	emit_signal("give_hero_item")

func emit_damage_hero():
	emit_signal("damage_hero")

func emit_damage_enemy():
	emit_signal("damage_enemy")
	
func emit_hero_turn():
	emit_signal("hero_turn")

func emit_enemy_turn():
	emit_signal("enemy_turn")

func emit_hero_dead():
	emit_signal("hero_dead")

func emit_stop_moving():
	emit_signal("stop_moving")

func emit_start_moving():
	emit_signal("start_moving")

func emit_set_music_volume():
	emit_signal("set_music_volume")

func emit_set_sfx_volume():
	emit_signal("set_sfx_volume")

func emit_set_player_model():
	emit_signal("set_player_model")

func emit_set_difficulty():
	emit_signal("set_difficulty")
