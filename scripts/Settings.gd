extends Node
class_name Settings

enum PLAYER_MODEL {RANDOM, MALE, FEMALE}

export (PLAYER_MODEL) var character_model = PLAYER_MODEL.RANDOM
export (float, .1, 1) var difficulty_increment = .5

export (float, -80, 10) var min_volume = -80
export (float, -80, 10) var max_volume = 2
export (float, -80, 10) var default_volume = -22
