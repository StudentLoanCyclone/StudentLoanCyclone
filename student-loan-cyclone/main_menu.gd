extends PanelContainer

var start_bracket_scene = preload("res://bracket_start.tscn")
var instructions_scene = preload("res://bracket_start.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_bracket_scene)


func _on_instructions_pressed() -> void:
	print("Instructionss Pressed")


func _on_quit_pressed() -> void:
	print("Quit Pressed")
