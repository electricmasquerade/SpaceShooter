class_name Lifecycle
extends Node

var spawn = {}
var elapsed_time = 0.0

var current_direction
var current_rotation
var speed

func init(root_node, enemy, _spawn):
	spawn = _spawn
	enemy.translate(spawn.coords)
	enemy.scale_object_local(spawn.scale)
	current_direction = spawn.direction
	speed = current_direction.length()
	current_rotation = spawn.rotation
	
func process(enemy, delta):
	elapsed_time += delta
	enemy.global_position.x += current_direction.x * delta
	enemy.global_position.z += current_direction.z * delta
	if current_rotation != Vector3.ZERO:
		enemy.rotate_x(current_rotation.x * delta)
		enemy.rotate_y(current_rotation.y * delta)
		enemy.rotate_z(current_rotation.z * delta)
		
	if elapsed_time > 20 and not GameManager.is_in_boundary(enemy):
		enemy.queue_free()
