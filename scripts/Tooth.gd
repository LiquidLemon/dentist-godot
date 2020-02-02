extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state
var isActive
var isScrewing

# Called when the node enters the scene tree for the first time.
func _ready():
	self.isActive = true
	self.isScrewing = false
	self.get_node("Arrow/Arrow").play("updown")
	self.state = "white"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_state(state):
	self.state = state
	self.animation = state
	
func crush():
	self.isActive = false
	self.play("invisible")
	
func screw_me():
	isScrewing = true
	self.get_node("Arrow").visible = false
	self.get_node("screw").visible = true
	self.get_node("mask").visible = true
