extends Area3D

@onready var safe: CSGBox3D = $Safe
var timer: Timer = Timer.new()

func _on_body_entered(body: Node3D) -> void:
	if body is Marble:
		safe.visible = false
		
		add_child(timer)
		timer.start(2)
		await timer.timeout
		
		safe.visible = true
