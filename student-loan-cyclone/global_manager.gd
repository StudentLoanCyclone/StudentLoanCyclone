extends Node

var player_start_spin = 100
var number_rounds_complete = 0
var current_match_state = null

var win_scene = preload("res://victory.tscn")
var lose_scene = preload("res://loss.tscn")

var start_story_scene = preload("res://story_scene.tscn")
var start_bracket_scene = preload("res://bracket_start.tscn")
var continue_bracket_scene = preload("res://bracket_continue.tscn")

var main_menu_scene = preload("res://main_menu.tscn")
var fight_scene = preload("res://main.tscn")

var launch_scene = preload("res://launch.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
