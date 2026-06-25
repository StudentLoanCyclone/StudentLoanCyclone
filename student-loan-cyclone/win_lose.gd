extends PanelContainer

@onready var winTracker = $VBoxContainer/WinCounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalManager.current_match_state == "victory":
		GlobalManager.number_rounds_complete += 1
		
	winTracker.text = "You won " + str(GlobalManager.number_rounds_complete) + " matches!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	if GlobalManager.number_rounds_complete < 8:
		get_tree().change_scene_to_packed(GlobalManager.continue_bracket_scene)
	
	elif GlobalManager.number_rounds_complete == 8:
		get_tree().change_scene_to_packed(GlobalManager.continue_bracket_scene)


func _on_return_pressed() -> void:
	get_tree().change_scene_to_packed(GlobalManager.main_menu_scene)
