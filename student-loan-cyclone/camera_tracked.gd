extends Camera3D

var selfRigidbody
var enemyRigidbody

var selfPosition
var enemyPosition

var targetPoint

var UItext

@onready var stamina_bar = $CanvasLayer/MarginContainer/HBoxContainer/StaminaBox/StaminaBar
@onready var health_bar = $CanvasLayer/MarginContainer/HBoxContainer/HealthBox/HealthBar



func _ready():
	selfRigidbody = get_parent().get_node("RigidBody3D")
	#UItext = get_node("Label3D")
	
	

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
		
		stamina_bar.value = selfRigidbody.current_stamina
		health_bar.value = selfRigidbody.current_spin
