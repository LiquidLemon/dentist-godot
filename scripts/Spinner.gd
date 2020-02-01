extends Node2D

export (float) var speed

func _process(delta):
	self.rotation_degrees += speed * delta
