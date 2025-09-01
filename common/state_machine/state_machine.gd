extends Node
class_name StateMachine

## What state should be active off rip. 
@export var initial_state: State
var current_state: State
var states: Dictionary

func _ready() -> void:
	# Add states to dict.
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child 
			child.transitioned.connect(_change_state)
	# Enter initial state. 		
	if initial_state:
		initial_state.enter_state()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state: 
		current_state.state_process(delta)

func _physics_process(delta: float) -> void:
	current_state.state_physics_process(delta)

func _change_state(state: State, new_state_name: StringName):
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.exit_state()
	new_state.enter_state()
	current_state = new_state
