class_name SfxManager
extends Node

@export_category("External Dependencies")

@export_group("Node Dependencies")
@export var beep: AudioStreamPlayer
@export var bootup: AudioStreamPlayer
@export var shutdown: AudioStreamPlayer
@export var health_loss: AudioStreamPlayer
@export var winner: AudioStreamPlayer
@export var press: AudioStreamPlayer
@export_group("Component Dependencies")

func play_beep() -> void:
	beep.play()

func play_bootup() -> void:
	bootup.play()

func play_shutdown() -> void:
	shutdown.play()
func play_health_loss() -> void:
	health_loss.play()
func play_winner() -> void:
	winner.play()

func play_press() -> void:
	press.play()
	
