extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var speed = 100

var dir = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	update_direction()
	
func update_direction():
	var dir_x = -Input.get_action_strength("control_left")
	if dir_x == 0:
		dir_x = Input.get_action_strength("control_right")
		
	var dir_y = -Input.get_action_strength("control_up")
	if dir_y == 0:
		dir_y = Input.get_action_strength("control_down")
		
	self.dir = Vector2(dir_x, dir_y)
	
	
func _physics_process(delta):
	self.translate(self.dir * self.speed * delta)


func _on_Area2D_area_entered(area):
#	area.find_parent()
	print(area.get_groups())
