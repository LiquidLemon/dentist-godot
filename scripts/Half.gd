extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var int2anim = {
		0: "white",
		1: "white",
		2: "white",
		3: "yellow",
		4: "yellow",
		5: "crack"	
	}
	var children = self.get_children()
	for ch in children:
		if ch.is_in_group("teeth"):
			var rand = rng.randi_range(0, 5)
			var anim = int2anim[rand]
			ch.set_state(anim)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
