extends Node2D

var prev_degrees
var total_spin
var enabled
var revolutions

func _ready():
	reset()
	
func reset():
	enabled = false
	self.prev_degrees = 0
	self.total_spin = 0
	self.revolutions = 0	

func _process(delta):
	if !enabled:
		self.visible = false
		return
	self.visible = true
	var dir_x = -Input.get_action_strength("right_left")
	if dir_x == 0:
		dir_x = Input.get_action_strength("right_right")
		
	var dir_y = -Input.get_action_strength("right_up")
	if dir_y == 0:
		dir_y = Input.get_action_strength("right_down")
		
	if dir_x * dir_x + dir_y * dir_y < sqrt(0.8):
		self.prev_degrees = null
		self.get_node("AnimatedSprite").frame = 0
		return
		
	var angle = atan2(dir_y, dir_x)
	var degrees = (rad2deg(angle) + 180)
	var frame = (int(degrees / (360 / 8)) + 2) % 8 + 1
	self.get_node("AnimatedSprite").frame = frame
	
	if prev_degrees != null:
		var diff = self.prev_degrees - degrees
		if diff > 180:
			diff -= 360
		elif diff < -180:
			diff += 360
		self.total_spin += diff
		revolutions = total_spin / 360.0
		
	self.prev_degrees = degrees
