extends Node3D

@onready var sparks_particle = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sparks_particle.emitting = true
	print("doing sparks!")
	
	await get_tree().create_timer(2).timeout
	
	if sparks_particle.finished:
		self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
