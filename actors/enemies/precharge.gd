extends State
class_name Precharge

@export var move_speed: float = 10.0  # Speed for wandering
var move_direction: Vector2
var wander_time: float
var detect_range: Area2D
var Charging_state: State

func initialize():
	detect_range = body.get_node("DetectionRange")
	Charging_state = get_parent().get_node("Charging")
	randomize_wander()  # Start wandering immediately

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)  # Random time for how long to wander

func process_state(delta: float):
	var potential_targets = detect_range.get_overlapping_bodies()

	# Check for player detection
	if not potential_targets.is_empty():
		Charging_state.target = (potential_targets[0] as CharacterBody2D)
		change_state.emit(Charging_state)  # Transition to charging state
		return  # Exit to prevent further movement processing

	# Handle wandering behavior
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()  # Randomize movement direction and time

	body.velocity = move_direction * move_speed  # Move in the wandering direction
	body.move_and_slide()  # Apply movement to the body

func _ready() -> void:
	$"../../AnimationPlayer".play("wolf_front_idle")
