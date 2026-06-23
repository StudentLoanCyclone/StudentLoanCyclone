extends RigidBody3D

# The player and enemy cyclones both use the same script.
# They are set up in different scenes so that the player can include the
# necessary camera and UI elements, and the enemy can exlude them.

@export var initial_spin : float = 200.00
@export var spin_decay : float = 10.0
@export var spin_boost : float = 20.0
@export var max_spin : float = 300.00


var current_spin: float = 0
var is_active : bool = false

var target : Node3D


@export var max_stamina := 100.0
var current_stamina = max_stamina

@export var selfcamera : Camera3D

@export var plastic1 : MeshInstance3D
@export var plastic2 : MeshInstance3D
@export var trim : MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if !self.is_in_group("player"):
		randomize_colour()
	
	launch()



func _physics_process(delta):
	#Spin decay.
	current_spin = move_toward(current_spin, 0, spin_decay * delta)
	
	current_spin += (linear_velocity.length()*0.02)	
	current_spin = clampf(current_spin, 0, max_spin)

	#Apply angular velocity for spin.
	angular_velocity.y = current_spin
	
	#Cause spinner to wobble as it slows.
	var upright_strength = (current_spin/initial_spin)
	var current_upright = global_transform.basis.y
	var upright_target = Vector3.UP
	
	var correction_torque = current_upright.cross(upright_target) * upright_strength
	
	apply_torque(correction_torque)
	
	linear_velocity.y = clampf(linear_velocity.y,-200, 30)
	
	current_stamina = move_toward(current_stamina, 100.0, 10.0 * delta)
	current_stamina = clamp(current_stamina + (5.0 * delta), 0.0, 100.0)
	
	if abs(self.global_position.x) > 27 or abs(self.global_position.z) > 27 or (abs(self.global_position.x) + abs(self.global_position.z)) > 40:
		if self.is_in_group("player"):
			self.global_position = Vector3(0, -10, 0)
			self.global_rotation = Vector3(0, 0, 0)
			self.linear_velocity = self.linear_velocity/2
			
		else:
			queue_free()
		
		
		

	if current_spin <= 0:
		#queue_free()
		pass



func _input(event):
	if self.is_in_group("player") and target:
		if event.is_action_pressed("attack"):
			if(current_stamina >= 50):
				attack()
		if event.is_action_pressed("defend"):
			if(current_stamina >= 50):
				defend()



func launch():
	current_spin = initial_spin
	angular_velocity.y = initial_spin
	is_active = true
	
	angular_velocity.x = randf_range(0,10)
	angular_velocity.z = randf_range(0,10)	



func attack():
	current_stamina -= 50
	
	var chasedir = (target.global_position - global_position).normalized()
	current_spin += spin_boost

	linear_velocity = chasedir * 20



func defend():
	current_stamina -= 50

	var distance = target.global_position - global_position
	
	if (distance).length() < 20:
		#this is the same as recieve impact but eh
		target.apply_central_impulse(distance.normalized() * 500)
		target.current_spin -= abs(current_spin) * 0.02



func _on_area_3d_body_entered(body): #for detection
	if body != self and body.name != "bowl":
		target = body
		#print(target)



func _on_area_3d_2_body_entered(body): #for bumpin
	if body is RigidBody3D and body != self and body.name != "bowl":
		var impact_vector = (body.global_position - global_position).normalized()
		impact_vector.y = 0
		
		var combined_spin = abs(self.current_spin) + abs(body.current_spin)
		var recoil_force = combined_spin * 2.5
		body.recieve_impact(impact_vector * recoil_force, current_spin)
		current_spin -= combined_spin * 0.05



func recieve_impact(force: Vector3, opposing_spin: float):
	if target:
		var target_v = target.linear_velocity

		apply_central_impulse(force + target_v)
		
		current_spin -= abs(opposing_spin + target_v.length()) * 0.3



func get_target():
	return target



func get_stamina():
	return current_stamina



func randomize_colour():
	print("randomizing colour....")
	
	# These colour combinations,a nd their reverses, are what the enemy will be randomised with.
	var colour_combos: Array[Array] = [
	[Color("#ff7d0c"), Color("#e6bb62")], # Orange and Yellow
	[Color("#ef002b"), Color("#b98837")], # Red and Gold
	[Color("#a933ff"), Color("#00cf38")], # Green and Purple
	[Color("#0085da"), Color("#d8c300")], # Blue and Yellow
	[Color("#000000"), Color("#ffffff")], # Black and White
	[Color("#8601cd"), Color("#ff4fa9")]  # Pink and Purple
	]
	
	var colour_num = randi()%6
	var colour_combo = colour_combos[colour_num]
	
	var random_order = randi()%2
	
	if random_order == 0:
		print("order 1...")
		print(plastic1.get_surface_override_material(0))
		plastic2.get_surface_override_material(0).albedo_color = colour_combo[0]
		trim.get_surface_override_material(0).albedo_color = colour_combo[1]
		
	else:
		print("order 2...")
		plastic1.get_surface_override_material(0).albedo_color = colour_combo[1]
		plastic2.get_surface_override_material(0).albedo_color = colour_combo[1]
		trim.get_surface_override_material(0).albedo_color = colour_combo[0]
	
	
	
	
	
