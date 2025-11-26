extends Node3D

@onready var platform_trigger: Area3D = $Environment/Objects/PlatformTrigger
@onready var moving_platform: MovingPlatform = $Environment/Objects/MovingPlatform

func _ready() -> void:
	get_tree().paused = false
	platform_trigger.body_entered.connect(_platform_trigger_body_entered)

func _platform_trigger_body_entered(body: Node3D) -> void:
	if body is Marble:
		moving_platform.one_shot_move()
		platform_trigger.queue_free()
