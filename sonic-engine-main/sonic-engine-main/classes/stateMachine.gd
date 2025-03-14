extends Node
class_name StateMachine

@export var initial_state: State
@export var entity: Player

var current_state: State
var currentStateName: String
var states: Dictionary = {}

signal state_changed(new_state)

func _ready():
	for child in get_children():
		if child is State:
			states[child.get_script().get_global_name().to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	#print(current_state)
	if current_state:
		current_state.update(delta)
	

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
	currentStateName = new_state.get_script().get_global_name()
	#print(current_state)
	emit_signal("state_changed", new_state)

func _current():
	return current_state.get_script().get_global_name()
	
