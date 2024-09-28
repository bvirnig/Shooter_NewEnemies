extends State
class_name EnemyWanderAndShoot

@export var shoot_range: float = 300.0  # Range within which the enemy can shoot
@export var bullet_scene: PackedScene  # The bullet scene to spawn
@export var shoot_interval: float = 2.0  # Time between shots

var player: CharacterBody2D  # Reference to the player
var shoot_timer: float = 0.0  # Timer for shooting
var detection_range: Area2D  # Area2D node for detecting the player

func _ready() -> void:
	$"../../AnimationPlayer".play("Shoot")

func initialize():
	shoot_timer = shoot_interval  # Initialize the shoot timer
	detection_range = body.get_node("DetectionRange")  # Assuming DetectionRange is a child of the enemy node

func process_state(delta: float):
	# Check for overlapping bodies in the detection range
	var overlapping_bodies = detection_range.get_overlapping_bodies()
	
	# Find the player in the overlapping bodies
	for body in overlapping_bodies:
		if body is CharacterBody2D:
			player = body
			break

	# If a player is detected, attempt to shoot
	if player:
		var distance_to_player = body.position.distance_to(player.position)

		# If within shoot range, shoot at the player
		if distance_to_player <= shoot_range:
			shoot_timer -= delta
			if shoot_timer <= 0:
				shoot_at_player()
				shoot_timer = shoot_interval  # Reset the timer

func shoot_at_player():
	# Create a bullet instance and set its position and direction
	var bullet = bullet_scene.instantiate()
	bullet.position = body.position
	bullet.fire((player.position - body.position).normalized(), 500)  # Fire towards the player
	get_tree().get_root().add_child(bullet)
	print("Shot a bullet at the player!")
