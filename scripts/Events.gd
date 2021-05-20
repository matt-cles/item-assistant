extends Spatial

signal give_hero_item
signal damage_hero
signal damage_enemy
signal hero_turn
signal enemy_turn
signal stop_moving
signal start_moving

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

func emit_stop_moving():
	emit_signal("stop_moving")

func emit_start_moving():
	emit_signal("start_moving")
