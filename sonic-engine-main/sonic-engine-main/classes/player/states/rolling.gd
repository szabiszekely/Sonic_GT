extends State
class_name rollingPlayer

@onready var player: Player = get_parent().entity

#var speed: float
var lastVel: Vector2
var intDir

#func _ready():
	##sprite.speed_scale = 3
	#hitBox.connect("area_entered", _collision)

func enter():
	#frc = 2.8125
	intDir = 1 if !player.animPlayer.flip_h else -1
	#sprite.play("roll")
	if player.up_direction == Vector2(0, 1) or player.up_direction == Vector2(0, -1):
		player.rollCollision.shape.size = Vector2(19, 29)
		pass
	else:
		player.rollCollision.shape.size = Vector2(29, 19)
		pass
	#runCollision.disabled = true; collision.disabled = false

func physics_update(delta):
	#var direction = Input.get_axis("left", "right")
	
	player.speed = move_toward(player.speed, 0, player.stats["rollFrc"])
	if player.dir != sign(player.speed) and player.dir != 0:
		player.speed -= player.stats["rollDec"] * sign(player.speed)
	
	if player.get_floor_angle() != 0:
		if player.uphill(player.speed):
			player.speed -= (player.stats["slpUp"] * -player.get_floor_normal().x)
			#print("up")
			#pass
		if !player.uphill(player.speed):
			player.speed -= (player.stats["slpDown"] * -player.get_floor_normal().x)
			#print("down")
	
	if abs(player.speed) > 150 and player.is_on_floor():
		if player.get_floor_angle() < deg_to_rad(46):
			player.up_direction = Vector2(0, -1)
			player.rollCollision.shape.size = Vector2(19, 29)
			player.floor_max_angle = deg_to_rad(65)
		elif player.get_floor_angle() > deg_to_rad(45) and player.get_floor_angle() < deg_to_rad(135):
			if sign(player.get_floor_normal().x) == -1:
				player.up_direction = Vector2(-1, 0)
			else:
				player.up_direction = Vector2(1, 0)
			player.rollCollision.shape.size = Vector2(29, 19)
			player.floor_max_angle = deg_to_rad(175)
		elif player.get_floor_angle() > deg_to_rad(134) and player.get_floor_angle() < deg_to_rad(226):
			player.up_direction = Vector2(0, 1)
			player.rollCollision.shape.size = Vector2(19, 29)
			player.floor_max_angle = deg_to_rad(180)
	else:
		player.floor_max_angle = deg_to_rad(65)
	
	if player.is_on_floor():
		#print([sign(player.speed), intDir])
		if sign(player.speed) != intDir or player.is_on_wall():
			
			#print(player.speed)
			if player.speed == 0:
				Transitioned.emit(self, "idlePlayer")
			elif "spring" in player.attributes:
				player.speed = 0
				Transitioned.emit(self, "idlePlayer")
			elif sign(player.speed) != intDir:
				Transitioned.emit(self, "airPlayer")
		
		if sign(player.get_wall_normal().x) == -sign(player.speed) and player.is_on_wall():
			player.speed = 0
		
		player.velocity = Vector2(player.speed*player.get_floor_normal().x, player.speed*player.get_floor_normal().y).rotated(deg_to_rad(90)) - player.get_floor_normal()*(13.125*abs(sign(player.speed)))
		if Input.is_action_just_pressed("jump") and player.jump:
			Transitioned.emit(self, "airPlayer")
	else:
		Transitioned.emit(self, "airPlayer")

#func _collision(area: Node):
	#if area.is_in_group("bounce") and get_parent().current_state.name == self.name:
		#area.queue_free()
