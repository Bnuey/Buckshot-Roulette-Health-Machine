@tool
class_name HealthDisplay
extends VBoxContainer

const HEALTH_SCENE: PackedScene = preload("res://scenes/health_point.tscn")


@export_category("External Dependencies")
@export var players: Array[Player]

@export_group("Node Dependencies")
@export var round_display: RoundDisplay
@export var player_name_labels: Array[Label]
@export var health_containers: Array[HealthContainer]
var alive_players: Array[Player]
var players_in_game: Array[Player]
var sitting_out: Array[Player]
var active_player_count: int = 0

@export var timer: Timer

@export_category("Player 3 & 4 Control Nodes")
@export var player_34_control_nodes: Array[Control]
@export var extra_players_shown: bool:
	get:
		return extra_players_shown
	set(value):
		extra_players_shown = value
		toggle_extra_players(extra_players_shown)

var initial_setup: bool = true

func _ready() -> void:
	global.start_game.connect(bootup)
	global.round_display_complete.connect(bootup)
	global.reset_game.connect(_reset)
	
	for n in health_containers:
		n.died.connect(player_died)

func toggle_extra_players(state: bool) -> void:
	for n in player_34_control_nodes:
		n.visible = state

func bootup() -> void:
	setup()
	sfx.play_bootup()
	await get_tree().create_timer(1).timeout
	sfx.play_beep()
	show()

func setup() -> void:
	if initial_setup: players_in_game.clear()
	alive_players.clear()
	
	for n in players:
		if n.in_game:
			if initial_setup:
				active_player_count += 1
				players_in_game.append(n)
		else:
			sitting_out.append(n)
	
	initial_setup = false
	for n in players_in_game:
		alive_players.append(n)
		n.health = 4
		n.dead = false
	
	for i in active_player_count:
		player_name_labels[i].visible_characters = -1
		player_name_labels[i].text = players[i].player_name
		health_containers[i].show()
	
	if active_player_count > 2:
		extra_players_shown = true
	
	for n in sitting_out:
		player_name_labels[n.id].text = ""
	
	# Setup Health Containers
	for n in health_containers:
		if n.player.in_game:
			n.setup()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	for i in active_player_count:
		if Input.is_action_just_pressed("player_" + str(i + 1)):
			if not players[i].in_game: return
			if players[i].dead: return
			
			@warning_ignore("standalone_ternary")
			health_containers[i].add_health() if Input.is_action_pressed("modifier") else health_containers[i].remove_health()


func player_died(player: Player) -> void:
	print("Player %s died" % [player.id])
	player.dead = true
	player_name_labels[player.id].visible_characters = 0
	alive_players.erase(player)
	
	if alive_players.size() <= 1:
		player_won(alive_players[0].id)

func player_won(id: int) -> void:
	timer.start(.5)
	global.current_round += 1
	await timer.timeout
	sfx.play_shutdown()
	hide()
	await get_tree().process_frame
	round_display.play_win(player_name_labels[id].text)


func _reset() -> void:
	for n in players:
		n.in_game = false
	alive_players.clear()
	players_in_game.clear()
	sitting_out.clear()
	initial_setup = true
	extra_players_shown = false
	active_player_count = 0
	
