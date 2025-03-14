extends State
class_name groundPlayer

@onready var player: Player = get_parent().entity

func enter():
	
	if player.up_direction == Vector2(0, 1) or player.up_direction == Vector2(0, -1):
		player.runCollision.shape.size = Vector2(19, 39)
		pass
	else:
		player.runCollision.shape.size = Vector2(39, 19)
		pass
	pass


func physics_update(delta):
	
	#slipping---------------------------------------------------
	
	if abs(player.speed) < 150 and player.get_floor_angle() >= deg_to_rad(36) and player.uphill(player.speed) and player.controlLockTimer == 0:
		player.up_direction = Vector2(0, -1)
		player.runCollision.shape.size = Vector2(19, 39)
		player.controlLockTimer = 30
		if player.get_floor_angle() > deg_to_rad(70):
			player.floor_max_angle = 0
		
		elif player.get_floor_angle() >= deg_to_rad(36):
			player.floor_max_angle = 0
			player.speed -= 30*sign(player.get_floor_normal().x)
	if player.controlLockTimer == 0: 
		if abs(player.speed) > 150:
			player.floor_max_angle = deg_to_rad(180)
		else:
			player.floor_max_angle = deg_to_rad(65)
	
	#directional movement----------------------------------------------
	if player.dir and player.controlLockTimer == 0:
		if sign(player.speed) == player.dir:
			player.speed = move_toward(player.speed, player.stats["topSpeed"]*player.dir, player.stats["acc"])
			player.animPlayer.flip_h = true if sign(player.speed) < 0 else false
		elif sign(player.speed) != player.dir:
			player.speed = move_toward(player.speed, player.stats["topSpeed"]*player.dir, player.stats["dec"])
	elif !player.dir:
		player.speed = move_toward(player.speed, 0, player.stats["frc"])
	
	#gravity while running
	if player.up_direction != Vector2(0, 1):
		player.speed -= player.stats["slp"] * -player.get_floor_normal().x if abs(player.stats["slp"] * -player.get_floor_normal().x) > 3.046875 else 0

	#changing states from floor to wall to ceiling------------

	if abs(player.speed) > 150:
		if player.get_floor_angle() < deg_to_rad(46):
			player.up_direction = Vector2(0, -1)
			player.runCollision.shape.size = Vector2(19, 39)
			player.floor_max_angle = deg_to_rad(65)
		elif player.get_floor_angle() > deg_to_rad(45) and player.get_floor_angle() < deg_to_rad(135):
			if sign(player.get_floor_normal().x) == -1:
				player.up_direction = Vector2(-1, 0)
			else:
				player.up_direction = Vector2(1, 0)
			player.runCollision.shape.size = Vector2(39, 19)
			player.floor_max_angle = deg_to_rad(175)
		elif player.get_floor_angle() > deg_to_rad(134) and player.get_floor_angle() < deg_to_rad(226):
			player.up_direction = Vector2(0, 1)
			player.runCollision.shape.size = Vector2(19, 39)
			player.floor_max_angle = deg_to_rad(180)
		
	
	
	if player.speed == 0 and player.is_on_floor():
		Transitioned.emit(self, "idlePlayer")
	
	if sign(player.get_wall_normal().x) == -sign(player.speed) and player.is_on_wall():
		player.speed = 0
	player.animPlayer.speed_scale = abs(3*(player.speed/60/6)) if abs(3*(player.speed/60/6)) > 1 else 1
	
	
	if player.is_on_floor():
		player.velocity = Vector2(player.speed*player.get_floor_normal().x, player.speed*player.get_floor_normal().y).rotated(deg_to_rad(90)) - player.get_floor_normal()*(13.125*abs(sign(player.speed)))
		
	
	if abs(player.speed) >= 60 and Input.is_action_pressed("down"):
		Transitioned.emit(self, "rollingPlayer")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and player.jump: #calling jumping
		player.runCollision.shape.size = Vector2(19, 39)
		Transitioned.emit(self, "airPlayer")
		
	
	if !player.is_on_floor(): #if of the floor, employ gravity physics
		Transitioned.emit(self, "airPlayer")
		pass
	
