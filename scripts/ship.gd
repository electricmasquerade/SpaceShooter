extends CharacterBody3D

@export var SPEED = 30

signal player_destroyed()

func _physics_process(delta: float) -> void:
	# Handle movement
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _on_area_3d_area_entered(area):
	player_destroyed.emit()
