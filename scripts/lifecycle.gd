class_name Lifecycle
extends Node

signal enemy_destroyed(source_node)
signal bullet_hit(enemy, bullet)

var spawn = {}
var elapsed_time = 0.0

var current_direction
var current_rotation
var speed

var max_hit_points = 0.0
var hit_points = 0.0

func init(root_node, enemy, _spawn):
	spawn = _spawn
	enemy.translate(spawn.coords)
	enemy.scale_object_local(spawn.scale)
	current_direction = spawn.direction
	speed = current_direction.length()
	current_rotation = spawn.rotation
	hit_points = spawn.hit_points
	max_hit_points = hit_points
	enemy_destroyed.connect(Callable(root_node, "_on_enemy_destroyed"))
	bullet_hit.connect(Callable(root_node, "_on_show_hit_effect"))
	
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

func process_hit(enemy, area):
	hit_points -= area.hit_points
	bullet_hit.emit(enemy, area)
	if hit_points <= 0:
		explode(enemy)
		
func explode(enemy):
	enemy_destroyed.emit(enemy)
	
