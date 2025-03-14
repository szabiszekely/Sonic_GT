extends State
class_name airPlayer

@onready var player: Player = get_parent().entity

var collisionSpeed
var jump: = false

func enter():
	jump = false
	player.up_direction = Vector2(0, -1)
	player.runCollision.shape.size = Vector2(19, 39)
	player.rollCollision.shape.size = Vector2(15, 29)
	player.floor_max_angle = deg_to_rad(85)
	if player.is_on_floor() and player.jump:
		jump = true
		player.animPlayer.play("roll")
		player.velocity.x -= 390 * sin(player._floor_angle())
		player.velocity.y -= 390 * cos(player._floor_angle())

func physics_update(delta):
	#var direction = Input.get_axis("left", "right")
	
	if !player.is_on_floor():
		if player.velocity.y > 0 and player.velocity.y <= 240:
			player.velocity.x -= int(player.velocity.x / 0.125) / 256
		player.velocity.y += player.stats["grv"]
		collisionSpeed = player.velocity.y
		
		if player.dir:
			player.velocity.x = move_toward(player.velocity.x, player.stats["topSpeed"]*player.dir, player.stats["airAcc"])
	
	else:
		if abs(player._floor_angle(true)) < 24:
			player.speed = player.velocity.x
		elif abs(player._floor_angle(true)) < 46:
			player.speed = collisionSpeed*0.5*-sign(player.get_floor_normal().y*-sign(player.get_floor_normal().x))
		
		elif abs(player._floor_angle(true)) > 45:
			player.speed = collisionSpeed*-sign(player.get_floor_normal().y*sign(player.get_floor_normal().x))
		
		if player.get_floor_angle() >= deg_to_rad(15):
			player.animPlayer.flip_h = true if sign(player.speed) == -1 else false
		
		if Input.is_action_pressed("down"):
			Transitioned.emit(self, "floor")
		else:
			Transitioned.emit(self, "groundPlayer")
	
	if Input.is_action_just_pressed("jump") and jump and player.doubleJump:
		Transitioned.emit(self, "doubleJump")
	player.animPlayer.rotation = move_toward(player.animPlayer.rotation, 0, 2.8125)
	
