extends State
class_name idlePlayer

@onready var player: Player = get_parent().entity

@export_category("states")
@export var rolling: Node
@export var run: Node

var charge: int = 0

func enter():
	#print(rad_to_deg(player.get_floor_angle()), rad_to_deg(player.floor_max_angle))
	if player.get_floor_angle() > player.floor_max_angle:
		Transitioned.emit(self, "airPlayer")

func physics_update(delta):
	if player.dir and charge == 0 and !Input.is_action_pressed("down"):
		Transitioned.emit(self, "groundPlayer")
	

	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("jump") and charge < 8*60 and player.spinDash:
			charge += 120
			player.animPlayer.speed_scale = 3
			player.dash = true
	else:
		if charge == 0:
			player.runCollision.shape.size = Vector2(19, 39); player.runCollision.global_position.y = player.global_position.y
			if Input.is_action_just_pressed("jump") and player.is_on_floor() and player.jump: #calling jumping
				player.runCollision.shape.size = Vector2(19, 39)
				Transitioned.emit(self, "airPlayer")
		else:
			var dir = 1 if !player.animPlayer.flip_h else -1
			player.speed = (480 + (floor(charge)/2)) * dir
			charge = 0
			Transitioned.emit(self, "rollingPlayer")
			player.dash = false
	
	if !player.is_on_floor():
		Transitioned.emit(self, "airPlayer")
	
