extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animation

var state

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state("none")
	play_anims("idle")

func set_state(state):
	self.state = state
	match state:
		"GAME_DRILL":
			pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func play_anims(name):
	match name:
		"drill":
			self.get_node("EyeL").play("scroll")
			self.get_node("EyeR").play("scroll")
			animation = "scroll"
		"blink":
			self.get_node("EyeL").play("blink")
			self.get_node("EyeR").play("blink")
		"idle":
			self.get_node("EyeL").play("idle")
			self.get_node("EyeR").play("idle")
			animation = "idle"
		"close":
			self.get_node("Bottom").get_node("Animation").play("close")
			self.get_node("Top").get_node("Animation").play("close")
			play_anims("blink")
		"lose":
			pass
			
func drill_speed(speed):
	self.get_node("EyeL").speed_scale = speed * 6
	self.get_node("EyeR").speed_scale = speed * 4
	
func reset_anim():
	if animation == "scroll":
		self.get_node("EyeL").speed_scale = 1
		self.get_node("EyeR").speed_scale = 1
		play_anims("idle")

func _on_blinkTimer_timeout():
	play_anims("blink")
	pass # Replace with function body.


func _on_EyeL_animation_finished():
	var type = self.get_node("EyeL").animation
	if type == "blink":
		play_anims(animation)

func _on_EyeR_animation_finished():
	var type = self.get_node("EyeL").animation
	if type == "blink":
		play_anims(animation)


