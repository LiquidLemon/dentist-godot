extends AnimatedSprite

export (String) var action

func _process(delta):
	if Input.is_action_just_pressed(action):
		self.frame = 1
		
	elif Input.is_action_just_released(action):
		self.frame = 0
		 
