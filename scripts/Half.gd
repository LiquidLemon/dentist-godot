extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
 
	var children = self.get_children()
	var teeth = []
	
	for ch in children:
		if ch.is_in_group("teeth"):
			teeth.push_back(ch)
			ch.set_state("white")
	
	for _i in range(2):
		var i = rng.randi_range(0, teeth.size() - 1)
		if rng.randi_range(0, 1) == 0:
			teeth[i].set_state("yellow")
		else:
			teeth[i].set_state("crack")
		
		teeth.remove(i)
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
