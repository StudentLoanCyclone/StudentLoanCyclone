extends MarginContainer

var story_text = "In the year 2037, the student loan crisis has only gotten more out of hand...#As students suffered more and more with crushing debt, a daring solution was envisioned.#It would be a competition, where the most highly skilled among indebted students could win forgiveness on their loans.#A competition played with metal-rimmed spinning tops called CYCLONES."

@onready var textBox = $HBoxContainer/VBoxContainer/VBoxContainer/RichTextLabel

var stringIndex = 0
var fcount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stringIndex < len(story_text) and fcount%2==0:
		var add_text = story_text[stringIndex]
		
		if add_text == '#':
			add_text = "[br]~[br]"
		
		textBox.append_text(add_text)
		
		stringIndex += 1
	
	if stringIndex >= len(story_text):
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_packed(GlobalManager.start_bracket_scene)
		
	
	fcount += 1
