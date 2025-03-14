extends Node

@export var player: Player
@export var stateMachine: StateMachine

var duck: bool = false

func _process(delta):
	
	#var dir = Input.get_axis("left", "right")
	var moveDir = 1 if !player.animPlayer.flip_h else -1
	if _get_speed() == 0:
		moveDir = 0
	var vel = player.velocity
	
	
	if player.is_on_floor() and stateMachine.current_state.name != "damagePlayer":
		if stateMachine.current_state.name == "groundPlayer":
			if moveDir != ceil(player.dir) and player.dir != 0 and _get_speed() >= 31:
				player.animPlayer.play("break")
			else:
				if _get_speed(vel) < 360:
					player.animPlayer.play("walk")
				else:
					player.animPlayer.play("run")
		elif stateMachine.current_state.name == "idlePlayer":
			if _get_speed(vel) == 0 and !duck and (!_currently_playing("duck") and !_currently_playing("bend up")):
				player.animPlayer.play("idle")
			if player.dash:
				#player.animPlayer.play("charge")
				pass
			if Input.is_action_pressed("down") and !duck:
				player.animPlayer.play("duck")
				duck = true
			elif Input.is_action_pressed("up") and !duck:
				player.animPlayer.play("bend up")
				duck = true
			elif (!Input.is_action_pressed("up") and !Input.is_action_pressed("down")) and duck:
				player.animPlayer.play_backwards(player.animPlayer.animation)
				duck = false
		elif stateMachine.current_state.name == "rollingPlayer" or Input.is_action_just_pressed("jump"):
			player.animPlayer.play("roll")
	elif stateMachine.current_state.name == "damagePlayer":
		player.animPlayer.play("damage")
	
	if "spring" in player.attributes:
		player.animPlayer.play("air")


func _get_speed(velocity: Vector2 = player.velocity):
	if player.is_on_floor():
		if velocity != Vector2(0, 0):
			velocity += player.get_floor_normal()*(13.125)
		return abs(velocity.x)+abs(velocity.y)
	else:
		return abs(velocity.x)

func _currently_playing(animation: String):
	if player.animPlayer.is_playing() and player.animPlayer.animation == animation:
		return true
	else:
		return false
