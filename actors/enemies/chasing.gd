extends State

@export var chase_speed: float = 5000.0  # Adjusted speed for chasing
@export var max_chase_distance: float = 300.0  # Maximum distance to chase the player
var target: CharacterBody2D

func initialize():
	# Initialize any necessary variables here
	pass

func process_state(delta: float):
	if target:
		# Handle chasing the player
		body.velocity = (target.position - body.position).normalized() * chase_speed * delta
		body.move_and_slide()
		
		# Check the distance to the player
		var distance_to_player = body.position.distance_to(target.position)
		if distance_to_player > max_chase_distance:
			change_to_idle()  # Change to idle state if the player is far enough away

func change_to_idle():
	var idle_state = get_parent().get_node("Idle")  # Assuming the Idle state is named "Idle"
	if idle_state:
		change_state.emit(idle_state)  # Emit signal to change to idle state
		print("Changed to Idle state.")  # Debug output
	else:
		print("Error: Idle state not found.")
