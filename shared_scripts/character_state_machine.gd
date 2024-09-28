extends CharacterBody2D
class_name CharacterStateMachine

@export var initial_state: State
@onready var current_state: State = initial_state

var all_state: Array[State] = []

signal change_state(next_state: State)  # Declare the signal for changing states

func _ready():
	for child in $States.get_children():
		if (child is State):
			all_state.append(child)
			child.change_state.connect(on_change_state)  # Connect the state change signal
			
			child.body = self  # Assign this machine as the body for states
			child.initialize()  # Initialize the state
		else:
			push_warning("Child " + child.name + " is not a state for " + self.name)

	initialize()  # Optional, depending on your needs

func initialize():
	pass  # Placeholder for any additional initialization logic

func _physics_process(delta: float):
	if current_state:
		current_state.process_state(delta)  # Call the current state process function

func on_change_state(next_state: State):
	if current_state:
		current_state.on_exit_state()  # Handle exit logic for the current state
	current_state = next_state  # Switch to the next state
	current_state.on_enter_state()  # Handle enter logic for the new state
