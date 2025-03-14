@tool
extends CharacterBody2D
class_name player_set_up

@export var characterName: String = "sonic"
@export var sprites:= Animation
@export var create := false

@export_group("collisions")
@export var runCollision := RectangleShape2D.new()
@export var rollCollision := RectangleShape2D.new()
@export var hitBox := RectangleShape2D.new()


func _ready() -> void:
	runCollision.size = Vector2(15, 39)
	rollCollision.size = Vector2(15, 29)
	hitBox.size = Vector2(17, 37)
	

func _process(delta: float) -> void:
	if create:
		_set_up()
		create = false

func _set_up():
	var node = [CollisionShape2D.new(), CollisionShape2D.new(), AnimatedSprite2D.new(), Area2D.new(), StateMachine.new(), preload("res://HUD/hud.tscn").instantiate()]
	node[0].name = "rollCollision"; node[1].name = "runCollision"; node[2].name = "animPlayer"; node[3].name = "hitBox"; node[4].name = "StateMachine"
	node[0].shape = runCollision; node[1].shape = rollCollision
	
	for n in node:
		add_child(n)
		if n is Area2D:
			var collision = CollisionShape2D.new()
			n.add_child(collision)
			collision.shape = hitBox
			collision.name = "hitBoxShape"
			collision.owner = get_tree().edited_scene_root
		elif n is StateMachine:
			n.name = "StateMachine"
			var states = [airPlayer.new(), groundPlayer.new(), idlePlayer.new(), damagePlayer.new(), rollingPlayer.new()]
			for state in states:
				n.add_child(state)
				state.name = str(state.get_script().get_global_name())
				state.owner = get_tree().edited_scene_root
			#n.owner = get_tree().edited_scene_root
		
		print(n.name)
		n.owner = get_tree().edited_scene_root
	
	name = characterName
	set_script(preload("res://classes/player/player.gd"))
