class_name Global
extends Node

@warning_ignore("unused_signal")
signal start_game
@warning_ignore("unused_signal")
signal round_display_complete
@warning_ignore("unused_signal")
signal reset_game

var current_round: int = 1

func start_new_game() -> void:
	current_round = 1
	start_game.emit()
