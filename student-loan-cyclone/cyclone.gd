extends RigidBody3D

# The player and enemy cyclones both use the same script.
# They are set up in different scenes so that the player can include the
# necessary camera and UI elements, and the enemy can exlude them.

@export var initial_spin : float = GlobalManager.player_start_spin
@export var spin_decay : float = 2.5
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

var defence_state = false

@onready var musicPlayer = $BattleMusic
@onready var Parry = $parry
@onready var Parried = $getParried
@onready var Death = $death

var impact_cooldown = 0
@onready var trail = $trim/trail


# Called when the node enters the scene tree for the first time.
func _ready():
	var trim_colour = trim.get_surface_override_material(0).albedo_color
	
	var trail_material = StandardMaterial3D.new()
	trail_material.albedo_color = trim_colour
	trail_material.ShadingMode = 0
	
	trail.draw_pass_1.material = trail_material
	
	launch()



func _physics_process(delta):
	#Spin decay.
	current_spin = move_toward(current_spin, 0, spin_decay * delta)
	
	#current_spin += (linear_velocity.length()*0.02)	
	current_spin = clampf(current_spin, 0, max_spin)

	#Apply angular velocity for spin.
	angular_velocity.y = current_spin
	
	if impact_cooldown > 0:
		impact_cooldown -= 1
	
	#Cause spinner to wobble as it slows.
	var upright_strength = (current_spin/initial_spin)
	var current_upright = global_transform.basis.y
	var upright_target = Vector3.UP
	
	var correction_torque = current_upright.cross(upright_target) * upright_strength
	
	apply_torque(correction_torque)
	
	linear_velocity.y = clampf(linear_velocity.y,-10, 10)
	
	linear_velocity.x = clampf(linear_velocity.x,-15, 15)
	linear_velocity.z = clampf(linear_velocity.z,-15, 15)
	
	current_stamina = move_toward(current_stamina, max_stamina, 10.0 * delta)
	current_stamina = clamp(current_stamina + (5.0 * delta), 0.0, max_stamina)
	
	if abs(self.global_position.x) > 27 or abs(self.global_position.z) > 27 or (abs(self.global_position.x) + abs(self.global_position.z)) > 40:
		if self.is_in_group("player"):
			self.global_position = Vector3(0, -10, 0)
			self.global_rotation = Vector3(0, 0, 0)
			self.linear_velocity = Vector3(0, 0, 0)
			
		else:
			current_spin = 0
		
		
	if current_spin <= 0:
		current_stamina = 0
		max_stamina = 0
		await get_tree().create_timer(2).timeout
		GlobalManager.current_match_state = "loss"
		
		
	if GlobalManager.current_match_state == "victory" and GlobalManager.number_rounds_complete < GlobalManager.final_round:
		musicPlayer.stop()
		get_tree().change_scene_to_packed(GlobalManager.win_scene)
		
	elif GlobalManager.current_match_state == "victory" and GlobalManager.number_rounds_complete == GlobalManager.final_round:
		musicPlayer.stop()
		get_tree().change_scene_to_packed(GlobalManager.final_scene)
		
	elif GlobalManager.current_match_state == "loss":
		musicPlayer.stop()
		get_tree().change_scene_to_packed(GlobalManager.lose_scene)



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
	current_stamina -= 33
	
	var chasedir = (target.global_position - global_position).normalized()
	current_spin += spin_boost

	linear_velocity = chasedir * 25
	
	activate_trail()



func defend():
	current_stamina -= 33
	
	var trim_colour = trim.get_surface_override_material(0).albedo_color
	
	plastic1.get_surface_override_material(0).emission = trim_colour
	plastic2.get_surface_override_material(0).emission = trim_colour
	trim.get_surface_override_material(0).emission = trim_colour
	
	defence_state = true
	
	await get_tree().create_timer(0.5).timeout
	
	plastic1.get_surface_override_material(0).emission = Color()
	plastic2.get_surface_override_material(0).emission = Color()
	trim.get_surface_override_material(0).emission = Color()
	
	defence_state = false



func _on_area_3d_body_entered(body): #for detection
	if body != self and body.name != "bowl":
		target = body
		#print(target)



func _on_area_3d_2_body_entered(body): #for bumpin
	if body.name == "EnemyRigidBody3D":
		var faster
		var impact_vector = (body.global_position - global_position).normalized()
		impact_vector.y = 0
		
		var self_velocity = self.linear_velocity
		var target_velocity = body.linear_velocity
		self_velocity.y = 0
		target_velocity.y = 0
		
		var combined_spin = abs(self.current_spin) + abs(body.current_spin)
		var recoil_force = combined_spin * 2.5
		
		if impact_cooldown == 0:
		
			if target_velocity.length() > self_velocity.length():
				faster = false
				
				if defence_state == false:
					print("Enemy Faster, Player Damaged")
					body.linear_velocity = -impact_vector * recoil_force
					body.current_spin += 50
					
					self.recieve_impact(impact_vector * recoil_force)
					self.current_spin -= 50
		
				else:
					print("Enemy Faster, Player Parried")
					body.recieve_impact(-impact_vector * recoil_force)
					body.current_spin -= 50
					
					Parry.play()
					
					self.linear_velocity = impact_vector * recoil_force
					self.current_spin += 50
				
			elif target_velocity.length() < self_velocity.length():
				faster = true
				
				if body.defence_state == false:
					print("Player Faster, Enemy Damaged")
					body.recieve_impact(-impact_vector * recoil_force)
					body.current_spin -= self.current_spin/4
					
					self.linear_velocity = impact_vector * recoil_force
					self.current_spin += 50
		
				else:
					print("Player Faster, Enemy Parried")
					print(body.defence_state)
					body.linear_velocity = -impact_vector * recoil_force
					body.current_spin += self.current_spin/25
					
					Parried.play()
					
					self.recieve_impact(impact_vector * recoil_force)
					self.current_spin -= 50
					
			else:
				self.recieve_impact(impact_vector * recoil_force * 2)
				body.recieve_impact(-impact_vector * recoil_force * 2)
				
			impact_cooldown = 30



func recieve_impact(force: Vector3):
	if target:
		var target_v = target.linear_velocity
		apply_central_impulse(force + target_v)


func activate_trail():
	
	trail.emitting = true	


func get_target():
	return target



func get_stamina():
	return current_stamina


	
	
	
	
