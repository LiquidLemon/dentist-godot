extends AnimatedSprite

export (String) var action

func _process(delta):
	var holding = self.get_node("Holding")
	if Input.is_action_just_pressed(action):
		self.frame = 1
		holding.play("default")
	elif Input.is_action_just_released(action):
		self.frame = 0
		holding.stop()
		holding.frame = 0
