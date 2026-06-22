extends Camera3D

var selfRigidbody
var enemyRigidbody

var selfPosition
var enemyPosition

var targetPoint

var UItext

func _ready():
	selfRigidbody = get_parent().get_node("RigidBody3D")
	UItext = get_node("Label3D")

func _physics_process(_delta):
	if enemyRigidbody == null:
		if selfRigidbody.target != null:
			enemyRigidbody = selfRigidbody.get_target()
	
	if enemyRigidbody != null:
		selfPosition = selfRigidbody.global_position
		enemyPosition = enemyRigidbody.global_position
		
		targetPoint = selfPosition.lerp(enemyPosition, 0.5)
		look_at(targetPoint)		
		
		self.global_position = selfPosition + Vector3(clamp(-targetPoint[0], -3.5, 3.5), 2.5, clamp(-targetPoint[2], -3.5, 3.5))
		
		UItext.text = "Spin: " + str(int(selfRigidbody.current_spin))
	
	
