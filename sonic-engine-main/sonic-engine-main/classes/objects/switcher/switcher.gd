@tool
extends Area2D
class_name switcher

@export var area: CollisionShape2D

@export var initialCollision: Node2D:
	set(newColl):
		initialCollision = newColl
		newCollision()

@export_category("switch between...")
@export var collision1: Node2D:
	set(newColl):
		collision1 = newColl
		newCollision()
@export var collision2: Node2D:
	set(newColl):
		collision2 = newColl
		newCollision()

func _enter_tree() -> void:
	body_entered.connect(switch)
	if Engine.is_editor_hint() and area == null:
		var zone = CollisionShape2D.new()
		zone.name = "area"
		add_child(zone)
		area = zone
		zone.owner = get_tree().edited_scene_root

func newCollision():
	if !(collision1 is CollisionShape2D or collision1 is CollisionPolygon2D) and collision1 != null:
		push_error("collision 1 has to be a shape")
	if !(collision2 is CollisionShape2D or collision1 is CollisionPolygon2D) and collision2 != null:# and !error[1]:
		push_error("collision 2 has to be a shape")
	if !(initialCollision is CollisionShape2D or initialCollision is CollisionPolygon2D) and initialCollision != null:
		push_error("initial collision has to be a shape")
	else:
		if collision1 == initialCollision and collision1 != null and collision2 != null:
			collision1.disabled = false
			collision2.disabled = true
		elif collision2 == initialCollision and collision1 != null and collision2 != null:
			collision2.disabled = false
			collision1.disabled = true

var player: Player


func switch(body: Node2D) -> void:
	if body is Player:
		if collision1.disabled:
			collision1.set_deferred("disabled", false)
			collision2.set_deferred("disabled", true)
		else:
			collision2.set_deferred("disabled", false)
			collision1.set_deferred("disabled", true)
