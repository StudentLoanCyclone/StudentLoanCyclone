extends RigidBody3D


@export var initial_spin : float = 200.00
@export var spin_decay : float = 10.0
@export var spin_boost : float = 20.0
@export var max_spin : float = 300.00


var current_spin: float = 0
var is_active : bool = false

var target : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	launch()

func _physics_process(delta):
	#decay
	current_spin = move_toward(current_spin, 0, spin_decay * delta)
	
	current_spin += (linear_velocity.length()*0.02)	
	current_spin = clampf(current_spin, 0, max_spin)

	
	#apply force
	angular_velocity.y = current_spin
	
	
	#wobble when slowing
	var upright_strength = (current_spin/initial_spin)
	var current_upright = global_transform.basis.y
	var upright_target = Vector3.UP
	
	var correction_torque = current_upright.cross(upright_target) * upright_strength
	
	apply_torque(correction_torque)
	
	linear_velocity.y = clampf(linear_velocity.y,-200, 30)

	
	
	if current_spin <= 0:
		#queue_free()
		pass

func _input(event):
	if self.is_in_group("player") and target:
		if event.is_action_pressed("attack"):
			attack()
		if event.is_action_pressed("defend"):
			defend()

func launch():
	current_spin = initial_spin
	angular_velocity.y = initial_spin
	is_active = true
	
	angular_velocity.x = randf_range(0,10)
	angular_velocity.z = randf_range(0,10)	

func attack():
	
	var chasedir = (target.global_position - global_position).normalized()
	current_spin += spin_boost

	linear_velocity = chasedir * 20

func defend():
	var distance = target.global_position - global_position
	print("defend works")
	
	if (distance).length() < 20:
		print("defend")
		#this is the same as recieve impact but eh
		target.apply_central_impulse(distance.normalized() * 500)
		target.current_spin -= abs(current_spin) * 0.02
		

func _on_area_3d_body_entered(body): #for detection
	if body != self and body.name != "bowl":
		target = body
		#print(target)

func _on_area_3d_2_body_entered(body): #for bumpin
	if body is RigidBody3D:
		var impact_vector = (body.global_position - global_position).normalized()
		impact_vector.y = 0
		
		var combined_spin = abs(self.current_spin) + abs(body.current_spin)
		var recoil_force = combined_spin * 2.5
		body.recieve_impact(impact_vector * recoil_force, current_spin)
		current_spin -= combined_spin * 0.05

func recieve_impact(force: Vector3, opposing_spin: float):
	if target:
		var target_v = target.linear_velocity
		print(target_v)
		print(self.current_spin)

		apply_central_impulse(force + target_v)
		
		current_spin -= abs(opposing_spin + target_v.length()) * 0.3

func get_target():
	return target
