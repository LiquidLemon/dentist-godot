extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	self.state = "white"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_state(state):
	self.state = state
	self.animation = state
