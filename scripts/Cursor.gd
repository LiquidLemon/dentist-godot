extends Node2D

const ButtonHint = preload("res://objects/ButtonHint.tscn")

export (float) var speed = 100
export (NodePath) var pickerTip
export (NodePath) var handTip
export (NodePath) var drillTip

var dir = Vector2.ZERO

var button = ButtonHint.instance()
var target
var state

func _ready():
	button.get_node("Holding").connect("animation_finished", self, "_on_hold_succeeded")
	_change_state("PICK")
	
func _change_state(state):
	match self.state:
		"PICK":
			get_node("Picker").visible = false
		"DRILL":
			get_node("Drill").visible = false
		"HAND":
			get_node("Hand").visible = false
	
	self.state = state
	
	match self.state:
		"PICK":
			get_node("Picker").visible = true
			get_node("Tip").transform = get_node(pickerTip).get_relative_transform_to_parent(self)
		"DRILL":
			get_node("Drill").visible = true
			get_node("Tip").transform = get_node(drillTip).get_relative_transform_to_parent(self)
		"HAND":
			get_node("Hand").visible = true
			get_node("Tip").transform = get_node(handTip).get_relative_transform_to_parent(self)
			

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
		
	target = tooth
		
	target.add_child(button)
	
func _on_hold_succeeded():
	target.remove_child(button)
	button.get_node("Holding").frame = 0
	
	match self.state:
		"PICK":
			self._change_state("HAND")

func _on_Tip_area_exited(area):
	var tooth = area.get_parent()
	if not tooth.is_in_group("teeth"):
		return
		
	tooth.remove_child(button)
