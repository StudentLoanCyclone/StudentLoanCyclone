extends PanelContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalManager.number_rounds_complete > 0:
		GlobalManager.number_rounds_complete = 0


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(GlobalManager.start_story_scene)


func _on_instructions_pressed() -> void:
	print("Instructionss Pressed")


func _on_quit_pressed() -> void:
	print("Quit Pressed")
