extends RigidBody3D


@export var initial_spin :float = 200.00
@export var spin_decay :float = 5.0


var current_spin: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	launch()
	
func launch():
	current_spin = initial_spin
	angular_velocity.y = initial_spin
	
	angular_velocity.x = randf_range(0,10)
	angular_velocity.z = randf_range(0,10)
	


func _physics_process(delta):
	
	#decay
	current_spin = move_toward(current_spin, 0, spin_decay * delta)
	
	#apply force
	angular_velocity.y = current_spin
	
	
	#wobble when slowing
	var upright_strength = (current_spin/initial_spin) * 10
	var current_upright = global_transform.basis.y
	var upright_target = Vector3.UP
	
	var correction_torque = current_upright.cross(upright_target) * upright_strength
	
	apply_torque(correction_torque)
	







	

	
