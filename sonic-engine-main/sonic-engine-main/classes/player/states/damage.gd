extends State
class_name damagePlayer

@onready var player: Player = get_parent().entity

@export_group("states")
@export var run: Node

var Hazard: float = 0
#var ring = preload("res://scenes/zones/global/rings/ring.tscn")
var death = false

func enter():
	player.animPlayer.rotation_degrees = 90
	if player.HUD.rings != 0:
		player.animPlayer.speed_scale = 0.5
		#Sprite.play("damage")
		player.speed = 0
		player.velocity.y = player.stats["knockBack"].y
		player.velocity.x = player.stats["knockBack"].x * sign(player.position.x-Hazard)
		player.inv = 80
		player.hitBox.set_collision_mask_value(2, false)
		if player.HUD.rings > 20:
			player.HUD.rings = 20
		for r in player.HUD.rings:
			print(Vector2.LEFT.rotated(deg_to_rad(180/player.HUD.rings * r)))
			#var obj = ring.instantiate()
			#get_parent().call_deferred("add_child", obj)
			#obj.position = player.position + (Vector2.LEFT.rotated(deg_to_rad(180/player.HUD.rings * r))*50)
			#obj.physics = true
			#obj.velocity = Vector2(100*sign(Vector2.LEFT.rotated(deg_to_rad(180/player.HUD.rings * r))).x, -200)
		player.HUD.rings = 0
		animationDamage()
	else:
		if player.inv == 0:
			death = true
			player.velocity = Vector2(0, -60*7)
		

func physics_update(delta):
	if !player.is_on_floor():
		player.velocity.y += player.stats["damageGrv"]
	else:
		Transitioned.emit(self, "idlePlayer")
		player.velocity = Vector2(0, 0)

func animationDamage():
	for i in 15:
		await get_tree().create_timer(0.12).timeout
		player.animPlayer.visible = !player.animPlayer.visible
	player.animPlayer.visible = true
