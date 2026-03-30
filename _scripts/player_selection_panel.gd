class_name PlayerSelectionPanel
extends VBoxContainer

@export_category("External Dependencies")
@export var health_display: HealthDisplay
@export var players: Array[Player]


@export_category("Node Dependencies")
@export var add_button: Button
@export var remove_button: Button
@export var start_button: Button
@export var player_name_parent: Control
@export var player_name_entry_array: Array[LineEdit]

@export_category("Component Dependencies")

func _ready() -> void:
	add_button.pressed.connect(_add_button_pressed)
	remove_button.pressed.connect(_remove_button_pressed)
	start_button.pressed.connect(_on_start_pressed)
	
	_create_new_player()
	_create_new_player()

func _add_button_pressed() -> void:
	if player_name_entry_array.size() >= 4: return
	_create_new_player()

func _remove_button_pressed() -> void:
	if player_name_entry_array.size() <= 2: return
	player_name_entry_array.pop_back().queue_free()

func _create_new_player() -> void:
	var player = LineEdit.new()
	player.text = "Player" + str(player_name_entry_array.size() + 1)
	player_name_parent.add_child(player)
	player_name_entry_array.append(player)


func _on_start_pressed() -> void:
	print(players.size())
	print(player_name_entry_array.size())
	for i in player_name_entry_array.size():
		players[i].player_name = player_name_entry_array[i].text
		players[i].in_game = true
	
	hide()
	global.start_new_game()
