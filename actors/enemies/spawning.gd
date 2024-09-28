extends State
class_name SpawnEnemies

@export var move_speed: float = 10.0  # Speed for wandering
@export var spawn_rate: float = 2.0  # Time in seconds between spawns
@export var enemy_scene: PackedScene  # The enemy scene to spawn
var move_direction: Vector2
var wander_time: float
var spawn_timer: float = 0.0

func initialize():
	randomize_wander()  # Start wandering immediately
	spawn_timer = spawn_rate  # Initialize the spawn timer


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)  # Random time for how long to wander

func process_state(delta: float):
	# Handle wandering behavior
	if wander_time > 0:
		wander_time -= delta
		body.velocity = move_direction * move_speed  # Move in the wandering direction
	else:
		randomize_wander()  # Randomize movement direction and time

	# Apply movement to the body
	body.move_and_slide()

	# Handle spawning of new enemies
	spawn_timer -= delta  # Decrement the spawn timer
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_rate  # Reset the timer

func spawn_enemy():
	# Check if enemy_scene is assigned
	if enemy_scene == null:
		print("Error: enemy_scene is not assigned!")
		return

	# Spawn the enemy and add it to the scene
	var new_enemy = enemy_scene.instantiate()
	new_enemy.position = body.position + Vector2(randf_range(-50, 50), randf_range(-50, 50))  # Random offset
	get_tree().get_root().add_child(new_enemy)
	print("Spawned a new enemy!")

func _ready() -> void:
	$"../../AnimationPlayer".play("coffin_summon")
	
