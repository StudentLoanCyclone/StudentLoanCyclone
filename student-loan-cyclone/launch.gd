extends PanelContainer

@onready var launch_bar = $HBox/LaunchBar
@onready var full_graphic = $HBox

var direction = 0
var spin_value = 0

var clicked = false

var scene_transition = preload("res://main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	full_graphic.modulate = Color(1.0, 1.0, 1.0, 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if full_graphic.modulate[3] < 1:
		full_graphic.modulate[3] += 0.01
		
	elif clicked == false:
		if direction == 0:
			launch_bar.value+=2
		
		else:
			launch_bar.value-=2
		
		
		
		if launch_bar.value >= 100:
			direction = 1
			
		if launch_bar.value <= 0:
			direction = 0


func _input(event):
	if event.is_action_pressed("attack") and clicked == false:
		var clicked_value = launch_bar.value
		
		if clicked_value >= 36 and clicked_value <= 51:
			spin_value = 300
			#Play good sound effect.
			
		else:
			if clicked_value < 36:
				spin_value = 225 * (clicked_value/36)
				
			elif clicked_value > 51:
				spin_value = 225 * ((49-(clicked_value-51))/49)
				
			#Play less good sound effect.
		
		
		clicked = true
		GlobalManager.player_start_spin = spin_value
		
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(scene_transition)
		
