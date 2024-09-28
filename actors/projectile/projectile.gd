extends Area2D

var velocity: Vector2 = Vector2(0,0)

func fire(forward: Vector2, speed: float):
	velocity = forward * speed
	look_at(position + forward)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta

func _on_time_to_live_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.hit(1)  # Call hit on the Enemy instance
	elif body is SpawnEnemy:
		body.hit(1)  # Call hit on the SpawnEnemy instance
	queue_free()  # Remove the projectile after hitting
