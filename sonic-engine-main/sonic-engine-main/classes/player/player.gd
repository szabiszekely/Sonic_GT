#@tool
extends CharacterBody2D
class_name Player

var start = false

var controlLockTimer: int
var dir = 0.0
var inv: int

@export var animPlayer: AnimatedSprite2D
@export var hitBox: Area2D
@export var HUD = preload("res://HUD/hud.tscn").instantiate()

@export var stats: Dictionary = { "acc": 2.813, 
	"airAcc": 5.626, 
	"damageGrv": 11.25, 
	"dec": 30, 
	"frc": 2.813, 
	"grv": 13.125, 
	"knockBack": Vector2(120, -240), 
	"rollDec": 7.5, 
	"rollFrc": 1.407, 
	"slp": 7.5, 
	"slpUp": 4.688, 
	"slpDown": 18.75,
	"topRollSpeed": 960, 
	"topSpeed": 1000#360,
}
@export var additionalStats: Dictionary = {
	"doubleJumpFrc": 390-97.5,
	"boostTopSpeed": 960,
}

@export_group("collisions")
@export var runCollision: CollisionShape2D
@export var rollCollision: CollisionShape2D


@export_group("physics")
@export var spinDash: bool = true
@export var jump: bool = true
@export var doubleJump: bool = true
@export var damage: bool = true

var invincible: bool = false
var dash: bool = false
var target

var attributes = []

var speed: float = 0



func _ready():
	
	hitBox.connect("area_entered", _collision)
	
	start = true

func _physics_process(delta):
	
	if controlLockTimer > 0 and is_on_floor_only() and get_floor_angle() < deg_to_rad(36):
		controlLockTimer = move_toward(controlLockTimer, 0, 0.01)
		dir = 0.0
	else:
		dir = sign(Input.get_axis("left", "right"))
	
	
	if inv > 0 and is_on_floor_only():
		inv = move_toward(inv, 0, 0.01)
		if inv == 0:
			hitBox.set_collision_mask_value(2, true)
			hitBox.monitoring = false
			hitBox.monitoring = true
	
	
	animPlayer.rotation = get_floor_angle() * sign(get_floor_normal().x) if get_floor_normal().x else get_floor_angle()
	if animPlayer.animation == "roll":
		set_collision_mask_value(4, false)
		rollCollision.position = -up_direction*5
		runCollision.disabled = true; rollCollision.disabled = false
	else:
		set_collision_mask_value(4, true)
		runCollision.disabled = false; rollCollision.disabled = true
	if HUD.rings == 0 and $StateMachine.current_state.name == "damagePlayer" and $StateMachine.current_state.death == true:
		runCollision.disabled = true; rollCollision.disabled = true; $hitBox/hitBoxShape.disabled = true
	
	if is_on_floor():
		if "spring" in attributes:
			attributes.remove_at(attributes.find("spring"))
	
	move_and_slide()


func _collision(body: Node):
	#print(body.get_groups())
	if body.is_in_group("damage") and damage:
		$StateMachine.current_state.Transitioned.emit($StateMachine.current_state, "damagePlayer")
		$StateMachine.current_state.Hazard = body.global_position.x
	if body.is_in_group("spring"):
		var result = Vector2(body.get_parent().power*-sin(body.get_parent().rotation), body.get_parent().power*cos(body.get_parent().rotation))
		if abs(result.x) > abs(result.y):
			speed = result.x
			animPlayer.flip_h = false if sign(result.x) == 1 else true
		elif abs(result.y) > abs(result.x):
			velocity.y = result.y
		else:
			velocity = result
		body.get_parent().bounce()
		attributes.append("spring")
	if body.is_in_group("ring"):
		body.get_parent().pickup()
		HUD.rings += 1
	if animPlayer.animation == "roll":
		if body.is_in_group("bounce"):
			velocity.y *= -1
		if body.is_in_group("enemy"):
			body.get_parent()._break()
		if body.is_in_group("monitor"):
			match body.get_parent().type:
				0:
					HUD.rings += 10
				1:
					attributes.append(speed)
	else:
		if body.is_in_group("enemy") and damage:
			$StateMachine.current_state.Transitioned.emit($StateMachine.current_state, "damage")


func _floor_angle(deg: bool = false)-> float:
	var result = -deg_to_rad(rad_to_deg(atan2(get_floor_normal().y, get_floor_normal().x))+90)
	if deg:
		return rad_to_deg(result)
	else:
		return result

func uphill(speed: float) -> bool:
	#print(rad_to_deg(get_floor_angle() * sign(get_floor_normal().x)))
	if sign(speed) == sign(-get_floor_normal().x):
		return true
	elif sign(speed) != sign(-get_floor_normal().x):
		return false
	else:
		return false
	


func _on_homing_body_entered(body):
	if body.is_in_group("target"):
		target = body
