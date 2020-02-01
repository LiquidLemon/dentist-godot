extends Node

const ButtonHint = preload("res://objects/ButtonHint.tscn")
var button = ButtonHint.instance()
var opt = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarkerContainer").add_child(button)
	button.get_node("Holding").connect("animation_finished", self, "_on_hold_succeeded")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("control_down"):
		opt += 1
		opt %= 3 
	if Input.is_action_just_pressed("control_up"):
		opt -= 1
		if opt == -1:
			opt = 2
	button.position = Vector2(0, 10 + opt * 40)
	

func _on_hold_succeeded():
	match opt:
		0:
			get_tree().change_scene("res://scenes/Game.tscn")
		1:
			pass
		2:
			get_tree().quit()
		
