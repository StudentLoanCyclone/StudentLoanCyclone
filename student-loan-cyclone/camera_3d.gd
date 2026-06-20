extends Camera3D

@export var mouse_sensitivity := 0.003
@export var pitch_limit := 89.0

var yaw := 0.0
var pitch := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta):
	rotation.x = pitch
	rotation.y = yaw
