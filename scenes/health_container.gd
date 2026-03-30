class_name HealthContainer
extends HBoxContainer

const HEALTH_SCENE: PackedScene = preload("res://scenes/health_point.tscn")
@export var player: Player

signal died(player: Player)

func setup() -> void:
	destroy_children()
	
	for i in 4: create_health()

func destroy_children() -> void:
	for n in get_children():
		n.queue_free()

func remove_health() -> void:
	get_child(0).queue_free()
	sfx.play_health_loss()
	
	player.health -= 1
	
	if get_child_count() -1 <= 0:
		died.emit(player)

func add_health() -> void:
	var child_count:int = get_child_count()
	if  child_count >= 4: return
	
	sfx.play_beep()
	
	player.health += 1
	create_health()

func create_health() -> void:
	var instance = HEALTH_SCENE.instantiate()
	add_child(instance)
