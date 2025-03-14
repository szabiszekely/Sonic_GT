extends Node
class_name State

signal Transitioned

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func timer(time: float, step: float):
	while time > 0:
		time -= step
	
