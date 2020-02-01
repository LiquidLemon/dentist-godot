extends Node2D

export (float) var speed = 100
export (NodePath) var pickerTip
export (NodePath) var handTip
export (NodePath) var drillTip

var dir = Vector2.ZERO

var button
var target
var state

func _ready():
	button = self.get_node("ButtonHint")
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
	if self.target:
		self.button.global_transform = Transform2D.IDENTITY
		self.button.global_position = self.target.global_position

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
	var potential_target = area.get_parent()

	match self.state:
		"PICK":
			if not potential_target.is_in_group("teeth"):
				return
				
			self.target = potential_target
			self.button.visible = true
		"HAND":
			if not potential_target.is_in_group("pickups"):
				return
				
			self.target = potential_target
			self.button.visible = true
		"DRILL":
			if not potential_target.is_in_group("teeth"):
				return

	
func _on_hold_succeeded():
	self.button.visible = false
	self.button.get_node("Holding").frame = 0
	self.button.get_node("Holding").stop()
	
	match self.state:
		"PICK":
			self._change_state("HAND")
			self.get_parent().get_node("EnterTheDrill").play("Drill")
		"HAND":
			self.target.queue_free()
			self._change_state(self.target.type)
			
	self.target = null

func _on_Tip_area_exited(area):
	self.target = null
	self.button.visible = false
	self.button.get_node("Holding").frame = 0
	self.button.get_node("Holding").stop()
