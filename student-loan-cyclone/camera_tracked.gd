extends Camera3D

var selfRigidbody
var enemyRigidbody

var selfPosition
var enemyPosition

var targetPoint

var UItext

var can_regen = true
var time_to_wait = 1.5
var s_timer = 0
var can_start_timer = true
@export var max_stamina := 100.0
@onready var stamina = $TextureProgressBar



func _ready():
	selfRigidbody = get_parent().get_node("RigidBody3D")
	UItext = get_node("Label3D")
	
	stamina.value = max_stamina
	
	

func _physics_process(delta):
	if enemyRigidbody == null:
		if selfRigidbody.target != null:
			enemyRigidbody = selfRigidbody.get_target()
	
	if enemyRigidbody != null:
		
		selfPosition = selfRigidbody.global_position
		enemyPosition = enemyRigidbody.global_position
		
		targetPoint = selfPosition.lerp(enemyPosition, 0.5)
		look_at(targetPoint)		
		
		self.global_position = selfPosition + Vector3(clamp(-enemyPosition[0], -3.5, 3.5), 2.5, clamp(-enemyPosition[2], -3.5, 3.5))
		
		UItext.text = "Spin: " + str(int(selfRigidbody.current_spin))
	
	#regen stamina
	if can_regen == true:
		stamina.value = move_toward(stamina.value, 100.0, 10.0 * delta)

	stamina.value = clamp(stamina.value + (5.0 * delta), 0.0, 100.0)
	
func get_stamina():
	return stamina.value
	
func set_stamina(value):
	if stamina.value >= value:
		stamina.value -= value
	return
	
