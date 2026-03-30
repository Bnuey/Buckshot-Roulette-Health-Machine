extends Node
class_name LerpComponent

@export var display: Node3D
@export var move_to: Node3D
@export var lerp_speed: float = 20

func _ready() -> void:
	display.top_level = true

func _physics_process(delta: float) -> void:
	display.global_position = display.global_position.lerp(move_to.global_position, delta * lerp_speed)
