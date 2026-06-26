extends PanelContainer

@onready var trim_r = $StoryMenu/VBoxContainer/TrimBox/VBoxContainer/HBoxContainer/R
@onready var trim_g = $StoryMenu/VBoxContainer/TrimBox/VBoxContainer/HBoxContainer/G
@onready var trim_b = $StoryMenu/VBoxContainer/TrimBox/VBoxContainer/HBoxContainer/B

@onready var plastic_r = $StoryMenu/VBoxContainer/PlasticBox/VBoxContainer/HBoxContainer/R
@onready var plastic_g = $StoryMenu/VBoxContainer/PlasticBox/VBoxContainer/HBoxContainer/G
@onready var plastic_b = $StoryMenu/VBoxContainer/PlasticBox/VBoxContainer/HBoxContainer/B

@onready var trim_panel = $StoryMenu/VBoxContainer/TrimBox/TrimPanel
@onready var plastic_panel = $StoryMenu/VBoxContainer/PlasticBox/PlasticPanel

var trim_colour
var plastic_colour

var trim_stylebox
var plastic_stylebox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trim_colour = GlobalManager.player_trim
	plastic_colour = GlobalManager.player_plastic
	
	trim_stylebox = StyleBoxFlat.new()
	plastic_stylebox = StyleBoxFlat.new()
	trim_stylebox.bg_color = trim_colour
	plastic_stylebox.bg_color = plastic_colour
	
	trim_panel.add_theme_stylebox_override("panel", trim_stylebox)
	plastic_panel.add_theme_stylebox_override("panel", plastic_stylebox)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	trim_colour[0] = trim_r.value
	trim_colour[1] = trim_g.value
	trim_colour[2] = trim_b.value
	
	plastic_colour[0] = plastic_r.value
	plastic_colour[1] = plastic_g.value
	plastic_colour[2] = plastic_b.value
	
	trim_stylebox.bg_color = trim_colour
	plastic_stylebox.bg_color = plastic_colour
	
	


func _on_return_pressed() -> void:
	GlobalManager.player_trim = trim_colour
	GlobalManager.player_plastic = plastic_colour
	get_tree().change_scene_to_packed(load("res://main_menu.tscn"))
