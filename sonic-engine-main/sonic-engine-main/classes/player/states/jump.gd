extends State
class_name jumpPlayer
#
#@export var player: player
#@export var sprite: AnimatedSprite2D
#@export var hitBox: Area2D
#
#@export_group("variables")
#@export var topSpeed = 360
#@export var fall = 150
#@export var grv = 13.125
#@export var airAcc = 5.625
#
#@export_category("states")
#@export var running: Node
#
#var speed: float
#var collisionSpeed: float
#
##func _ready():
	##hitBox.connect("area_entered", _collision)
#
#
#func enter():
	#sprite.speed_scale = 2
	#player.floor_max_angle = deg_to_rad(85)
	##sprite.play("roll")
	#player.up_direction = Vector2(0, -1)
	#player.velocity.x -= 390 * sin(player._floor_angle())
	#player.velocity.y -= 390 * cos(player._floor_angle())
	#
#
#func physics_update(delta):
	#var direction = Input.get_axis("ui_left", "ui_right")
	#
	#if !player.is_on_floor():
		#if !Input.is_action_pressed("jump") and player.velocity.y <= -240:
			#player.velocity.y = -240
		#if player.velocity.y > 0 and player.velocity.y <= 240:
			#player.velocity.x -= int(player.velocity.x / 0.125) / 256
		#player.velocity.y += grv
	#else:
		#if abs(player._floor_angle(true)) < 24:
			#speed = player.velocity.x
		#elif abs(player._floor_angle(true)) < 46:
			#if player.velocity.x > collisionSpeed*0.5*-sign(sin(player._floor_angle())):
				#speed = player.velocity.x
			#else:
				#speed = collisionSpeed*0.5*-sign(sin(player._floor_angle()))
		#
		#elif abs(player._floor_angle(true)) > 45:
			#if player.velocity.x > speed*-sign(sin(player._floor_angle())):
				#speed = player.velocity.x
			#else:
				#speed = collisionSpeed*-sign(sin(player._floor_angle()))
		#
		#running.speed = speed
		#Transitioned.emit(self, "floor")
	#
	#
	#if direction:
		#player.velocity.x = move_toward(player.velocity.x, topSpeed*direction, airAcc)
	#
	#player.sprite.rotation = move_toward(player.sprite.rotation, 0, 2.8125)
	#pass

#func _collision(area: Node):
	#if area.is_in_group("bounce") and get_parent().current_state.name == self.name:
		#player.velocity.y = -player.velocity.y
		#area.queue_free()
	#pass

#
#func _on_hitbox_body_entered(body):
	#print([body, body.is_in_group("bounce")])
	#if body.is_in_group("bounce"):
		#print("bounce")
		#player.velocity.y = -player.velocity.y
	#pass # Replace with function body.
