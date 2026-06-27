extends Node

var player_start_spin = 100
var number_rounds_complete = 0
var final_round = 3
var current_match_state = null

var win_scene = preload("res://victory.tscn")
var lose_scene = preload("res://loss.tscn")
var final_scene = preload("res://final.tscn")

var start_story_scene = preload("res://story_scene.tscn")
var start_bracket_scene = preload("res://bracket_start.tscn")
var continue_bracket_scene = preload("res://bracket_continue.tscn")
var final_bracket_scene = preload("res://bracket_final.tscn")

var main_menu_scene = preload("res://main_menu.tscn")
var instructions_scene = preload("res://instructions_scene.tscn")
var customize_scene = preload("res://customize_scene.tscn")

var fight_scene = preload("res://main.tscn")

var launch_scene = preload("res://launch.tscn")

var player_trim = Color("0091e8")
var player_plastic = Color("77fffa")

var web_called = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !web_called and number_rounds_complete == final_round + 1:
		meta_game_complete("jim_maryam_ethan/student_loan_cyclone") 
	
	
func meta_game_complete(gameId: String) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("localStorage.setItem(\"%s\", new Date().toJSON());" % gameId)
	web_called = true
	print(gameId)
