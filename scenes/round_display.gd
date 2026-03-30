class_name RoundDisplay
extends Control

@export_category("External Dependencies")

@export_group("Node Dependencies")
@export var win_anim: AnimationPlayer
@export var win_label: Label
@export var DON_score_ui: Label
@export var DON_label: Label
@export var DON_yes: Button
@export var DON_no: Button
@export var DON: AudioStreamPlayer
@export var DON_show: AudioStreamPlayer
@export var DON_hide: AudioStreamPlayer
@export var timer: Timer

@export_group("Component Dependencies")

var lerp_start: int
var lerp_end: int = 70000
var elapsed: float
var dur: float = 3

var score_lerping: bool

var score_timer: Timer

func _process(_delta: float) -> void:
	if score_lerping:
		lerp_score()

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
	DON_score_ui.show()
	DON_show.play()
	DON.play()
	timer.start(1.65)
	await timer.timeout
	score_lerping = true
	timer.start(3)
	await timer.timeout

func lerp_score() -> void:
	elapsed += get_process_delta_time()
	var c = clampf(elapsed / dur, 0.0, 1.0)
	var score = lerp(lerp_start, lerp_end, c)
	DON_score_ui.text = str(int(score))
