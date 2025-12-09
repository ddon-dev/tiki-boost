extends CSGCylinder3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Guardar posición inicial en X
	_start_x = global_transform.origin.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Mover en X dentro del rango [_start_x - HALF_RANGE, _start_x + HALF_RANGE]
	var pos: Vector3 = global_transform.origin
	pos.x += speed * delta * _direction

	if pos.x > _start_x + HALF_RANGE:
		pos.x = _start_x + HALF_RANGE
		_direction = -1.0
	elif pos.x < _start_x - HALF_RANGE:
		pos.x = _start_x - HALF_RANGE
		_direction = 1.0

	# Aplicar la nueva posición global
	var t = global_transform
	t.origin = pos
	global_transform = t


# --- Variables para el movimiento ---
@export var speed: float = 5.0 # velocidad en unidades por segundo (editable en el Inspector)

var _start_x: float = 0.0
@export var _direction: float = 1.0
const HALF_RANGE: float = 50.0 # mitad del rango (50 -> rango total 100)
