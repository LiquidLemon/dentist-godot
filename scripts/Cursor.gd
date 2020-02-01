extends Node2D

const ButtonHint = preload("res://objects/ButtonHint.tscn")

export (float) var speed = 100

var dir = Vector2.ZERO

var button = ButtonHint.instance()

func _process(_delta):
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
	self.rotation_degrees = -self.dir.x * 6 - self.dir.y * 1

func _on_Area2D_area_entered(area):
	var tooth = area.get_parent()
	if not tooth.is_in_group("teeth"):
		return
		
	tooth.add_child(button)

func _on_Tip_area_exited(area):
	var tooth = area.get_parent()
	if not tooth.is_in_group("teeth"):
		return
		
	tooth.remove_child(button)
