extends State
class_name Idle

@export var move_speed: float = 10.0  # Speed for wandering
var move_direction: Vector2
var wander_time: float
var detect_range: Area2D
var chasing_state: State

func initialize():
	detect_range = body.get_node("DetectionRange")
	chasing_state = get_parent().get_node("Chasing")
	randomize_wander()  # Start wandering immediately
	
func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)  # Random time for how long to wander

func process_state(delta: float):
	var potential_targets = detect_range.get_overlapping_bodies()
	
	if not potential_targets.is_empty():
		chasing_state.target = (potential_targets[0] as CharacterBody2D)
		change_state.emit(chasing_state)  # Transition to chasing state
	else:
		# If no targets are detected, continue wandering
		if wander_time > 0:
			wander_time -= delta
			body.velocity = move_direction * move_speed  # Move in the wandering direction
		else:
			randomize_wander()  # Randomize movement direction and time

		# Apply movement to the body
		body.move_and_slide()
		
	

func _ready() -> void:
	$"../../AnimationPlayer".play("cactus_front _idle")
