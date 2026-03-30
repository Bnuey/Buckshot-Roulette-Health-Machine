class_name NameEntry
extends PanelContainer

@export var players_menu: Control
@export var players: Array[HealthContainer]

@export_category("Node Dependencies")
@export var player_button_2: Button
@export var player_button_3: Button
@export var player_button_4: Button

func _ready() -> void:
	player_button_2.pressed.connect(_player_2_selected)
	player_button_3.pressed.connect(_player_3_selected)
	player_button_4.pressed.connect(_player_4_selected)


func _select_players(num: int) -> void:
	for i in num:
		players[i].visible = true
		players[i].setup()
	
	visible = false
	players_menu.visible = true


func _player_2_selected() -> void:
	_select_players(2)

func _player_3_selected() -> void:
	_select_players(3)

func _player_4_selected() -> void:
	_select_players(4)
