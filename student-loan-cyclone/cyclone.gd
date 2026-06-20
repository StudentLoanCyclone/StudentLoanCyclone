extends RigidBody3D


@export var initial_speed :float = 200.00
@export var spin_decay :float = 5.0
@export var spin_max : float = 300


var current_spin: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_spin = initial_speed
	angular_velocity.y = initial_speed


func _physics_process(delta):
	
	#decay
	current_spin = move_toward(current_spin, 0, spin_decay * delta)
	
	#apply force
	angular_velocity.y = current_spin
	
	
	#wobble when slowing
	var upright_strength = (current_spin/spin_max) * 10
	var current_upright = global_transform.basis.y
	var upright_target = Vector3.UP
	
	var correction_torque = current_upright.cross(upright_target) * upright_strength
	
	apply_torque(correction_torque)
	







	

	
