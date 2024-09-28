extends State
class_name Charging

@export var normal_speed: float = 2500.0  # Normal speed for wandering
@export var chase_speed: float = 12000.0   # Speed for charging (double the normal speed)
@export var max_chase_distance: float = 300.0  # Maximum distance to charge at the player
@export var charge_duration: float = 5.0  # Duration before charging starts
@export var active_duration: float = 7.0   # Duration for active charging

var target: CharacterBody2D
var charge_timer: float = 0.0  # Timer for duration before charging
var active_timer: float = 0.0  # Timer for how long to charge towards the player

func initialize():
	# Initialize the charge timers
	charge_timer = charge_duration
	active_timer = active_duration

func process_state(delta: float):
	if target:
		# Decrement the charge timer
		charge_timer -= delta

		# If the timer is still running, do nothing
		if charge_timer > 0:
			body.velocity = Vector2.ZERO  # Stop movement during the initial charge timer
			# Switch to idle animation during precharge
			$"../../AnimationPlayer".play("wolf_front_idle")
			return  # Wait for the timer to finish

		# Now we are in the active charging phase
		if active_timer > 0:
			# Move towards the player at chase_speed
			body.velocity = (target.position - body.position).normalized() * chase_speed * delta
			body.move_and_slide()

			# Play running animation during charge
			$"../../AnimationPlayer".play("wolf_run")

			# Decrement the active timer
			active_timer -= delta
		else:
			change_to_precharge()  # Change to precharge state after active timer expires

		# Check the distance to the player
		var distance_to_player = body.position.distance_to(target.position)
		if distance_to_player > max_chase_distance:
			change_to_precharge()  # Change to precharge state if the player is far enough away

func change_to_precharge():
	var precharge_state = get_parent().get_node("Precharge")  # Assuming the Precharge state is named "Precharge"
	if precharge_state:
		# Reset the timers when changing to Precharge state
		charge_timer = charge_duration
		active_timer = active_duration

		change_state.emit(precharge_state)  # Emit signal to change to precharge state
		print("Changed to Precharge state.")  # Debug output
	else:
		print("Error: Precharge state not found.")
