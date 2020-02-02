extends Node2D

export (float) var speed = 100
export (NodePath) var pickerTip
export (NodePath) var handTip
export (NodePath) var drillTip

var dir = Vector2.ZERO

var button
var drillGame
var target
var selected_target
var state
var drillSpeed
var rng = RandomNumberGenerator.new()
var SWEET

func _ready():
	SWEET = [ 0.6, 0.9 ]
	rng.randomize()
	drillSpeed = 0
	button = self.get_node("ButtonHint")
	drillGame = self.get_node("DrillGame")
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
		"SCREW":
			get_node("Screw").visible = false
	
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
		self.drillGame.global_transform = Transform2D.IDENTITY
		self.drillGame.global_position = self.target.global_position
		self.drillGame.global_position.y -= 13
	
	var rtStrength = Input.get_action_strength("rt")
	
	drillSpeed += (rtStrength - 0.5) * 0.1
	drillSpeed += rng.randf_range(0, 0.025)
	
	drillSpeed = clamp(drillSpeed, 0, 1)
	self.get_node("DrillGame/Slider").set_pos(drillSpeed)
	
	if drillSpeed > SWEET[0] && drillSpeed < SWEET[1]:
		pass
	else:
		self.get_node("DrillGame/Timer").stop()
		self.get_node("DrillGame/Timer").start()
			
	
	if rtStrength > 0:
		self.get_node("Drill").play("drilling")
		if self.target != null:
			self.get_parent().play_anims("drill")
			self.get_parent().drill_speed(drillSpeed)
			self.get_node("DrillGame/RT").position = Vector2(54, rtStrength * 5)
	else:
		self.get_node("DrillGame/RT").position = Vector2(54, 0)
		self.get_node("Drill").play("idle")
		self.get_parent().reset_anim()

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
			self.target = potential_target
			if self.target.isActive:
				self.drillGame.visible = true

	
func _on_hold_succeeded():
	self.button.visible = false
	self.button.get_node("Holding").frame = 0
	self.button.get_node("Holding").stop()
	
	match self.state:
		"PICK":
			self.target.get_node("Arrow").visible = true
			self._change_state("HAND")
			self.selected_target = self.target
			self.get_parent().get_node("EnterTheDrill").play("Drill")
		"HAND":
			self.target.queue_free()
			self._change_state(self.target.type)
			
	self.target = null

func _on_Tip_area_exited(area):
	self.target = null
	self.button.visible = false
	self.drillGame.visible = false
	self.button.get_node("Holding").frame = 0
	self.button.get_node("Holding").stop()


func _on_Timer_timeout():
	self.target.crush()
	self.drillGame.visible = false
	if selected_target == self.target:
		self._change_state("HAND")
		pass
	pass # Replace with function body.
