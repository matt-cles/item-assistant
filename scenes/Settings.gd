extends Node
class_name Settings

enum PLAYER_MODEL {RANDOM, MALE, FEMALE}

export (PLAYER_MODEL) var character_model = PLAYER_MODEL.RANDOM
export var difficulty_increment = .5
