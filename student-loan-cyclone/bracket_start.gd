extends PanelContainer

@onready var video_player = $VideoStreamPlayer
var donePlaying = false
var slideSpeed = 1

var scene_transition = preload("res://main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	
	video_player.stop()
	
	await get_tree().create_timer(2).timeout
	
	video_player.play()
	
	await get_tree().create_timer(4).timeout
	
	donePlaying = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if donePlaying:
		if video_player.position.y > -1200:
			video_player.position.y -= slideSpeed
			slideSpeed += 1
			
	if video_player.position.y < -1200:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(scene_transition)
