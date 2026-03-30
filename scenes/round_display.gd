class_name RoundDisplay
extends Control

@export_category("External Dependencies")

@export_group("Node Dependencies")
@export var win_anim: AnimationPlayer
@export var win_label: Label
@export var DON_UI: Control
@export var DON_label: Control
@export var DON_score: Control
@export var DON_yes: Button
@export var DON_no: Button
@export var DON: AudioStreamPlayer
@export var DON_show: AudioStreamPlayer
@export var DON_hide: AudioStreamPlayer
@export var timer: Timer
@export var name_entry: Control

var DON_deciding: bool

@export_group("Component Dependencies")

var lerp_start: int
var lerp_end: int = 70000
var elapsed: float
var dur: float = 3

var score_lerping: bool

var score_timer: Timer

var should_double: bool

func _ready() -> void:
	DON_yes.pressed.connect(yes_pressed)
	DON_no.pressed.connect(no_pressed)

func _process(_delta: float) -> void:
	if score_lerping:
		lerp_score()
	if DON_deciding:
		if Input.is_action_just_pressed("player_1"): yes_pressed()
		if Input.is_action_just_pressed("player_2"): no_pressed()

func play_win(player_name: String) -> void:
	win_label.text = player_name + " WON!"
	show()
	win_anim.play("win_animation")
	await win_anim.animation_finished
	if global.current_round != 4:
		win_anim.play("round" + str(global.current_round))
	else:
		double_or_nothing()
		return
	await win_anim.animation_finished
	global.round_display_complete.emit()

func double_or_nothing() -> void:
	DON_deciding = true
	if should_double: 
		lerp_start = lerp_end
		lerp_end *= 2
		elapsed = 0
	else: lerp_end -= randi_range(0, 10000)
	should_double = true
	
	DON_show.play()
	timer.start(.5)
	await timer.timeout
	DON_UI.show()
	DON_score.modulate.a = 1
	DON.play()
	timer.start(1.65)
	await timer.timeout
	score_lerping = true
	timer.start(3.5)
	await timer.timeout
	DON_yes.modulate.a = 1
	DON_no.modulate.a  = 1
	DON_label.modulate.a  = 1

func lerp_score() -> void:
	elapsed += get_process_delta_time()
	var c = clampf(elapsed / dur, 0.0, 1.0)
	var score = lerp(lerp_start, lerp_end, c)
	DON_score.text = str(int(score))
	
	if score == lerp_end: score_lerping = false

func yes_pressed() -> void:
	DON_deciding = false
	DON_hide.play()
	sfx.play_press()
	timer.start(0.8)
	await timer.timeout
	global.start_new_game()
	hide_menu()

func hide_menu() -> void:
	DON_UI.hide()
	DON.stop()
	DON_yes.modulate.a = 0
	DON_no.modulate.a  = 0
	DON_label.modulate.a  = 0
	DON_score.modulate.a = 0

func no_pressed() -> void:
	DON_deciding = false
	DON_hide.play()
	sfx.play_press()
	timer.start(0.8)
	await timer.timeout
	hide_menu()
	timer.start(0.5)
	await timer.timeout
	sfx.play_bootup()
	timer.start(1)
	await timer.timeout
	global.reset_game.emit()
	sfx.play_beep()
	name_entry.show()
	lerp_start = 0
	lerp_end = 70000
	elapsed = 0
	should_double = false
	DON_score.text = "0"
