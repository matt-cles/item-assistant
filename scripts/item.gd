extends Spatial
class_name Item, "res://assets/icons/item_icon.png"

enum DAMAGE_TYPES {FIRE, ICE, WATER, POISON, STEALTH, BLUNT, PIERCE, SLASH, NONE}
enum RESTORE_TYPES {HEALTH, MANA, STAMINA, NONE}

export var damage = 10
export var restore_amount = 10
export var stamina_cost = 0
export var mana_cost = 0
export (DAMAGE_TYPES) var damage_type = DAMAGE_TYPES.NONE
export (RESTORE_TYPES) var restore_type = RESTORE_TYPES.NONE
