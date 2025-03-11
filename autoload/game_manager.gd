extends Node

@onready var small_star_scene = preload("res://scenes/small_star.tscn")
@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var explosion_scene = preload("res://scenes/explosion.tscn")
@onready var hit_effect_scene = preload("res://scenes/hit_effect.tscn")

var player
var camera

var boundary = {
	"left": 0, 
	"right": 0, 
	"top": 0, 
	"bottom": 0
}

var boundary_margin = 10

func set_player(_player):
	player = _player
	
func set_camera(_camera):	
	camera = _camera
	
func to_2D(vector3):	
	return camera.unproject_position(vector3)
	
	
func fire_player_weapon(root_node):
	for weapon in player.weapons:
		if weapon.active:
			var bullet = bullet_scene.instantiate()
			bullet.init(weapon)
			root_node.add_child(bullet)

	
func set_boundary(left, right, top, bottom): 
	boundary.left = left + boundary_margin
	boundary.right = right - boundary_margin
	boundary.top = top + boundary_margin
	boundary.bottom = bottom - boundary_margin
	
func is_in_boundary(node, add_margin = true):
	var margin = boundary_margin if add_margin else 0
	return (node.global_position.x > boundary.left - margin 
		and node.global_position.x < boundary.right + margin 
		and node.global_position.z > boundary.top - margin 
		and node.global_position.z < boundary.bottom + margin)

# Star functions for background

func spawn_stars(root_node):
	for i in 50:
		spawn_star(root_node, false)
		
func spawn_star(root_node, on_top): 
	var star: Node = small_star_scene.instantiate()
	star.init(
		randf_range(boundary.left - 50, boundary.right + 50), 
		randf_range(-20,-50),
		boundary.top - boundary_margin if on_top else 
		randf_range(boundary.top, boundary.bottom),
		randf_range(0.05, 0.3)) 
	root_node.add_child(star)
	
	
func process_background(root_node, delta):
	for small_star in get_tree().get_nodes_in_group("small_star"):
		small_star.global_position.z += small_star.vertical_speed * delta
		var z = small_star.position.z
		if z > boundary.bottom + boundary_margin:
			small_star.queue_free()
			spawn_star(root_node, true)
		
# Asteroid functions

func spawn_asteroids(root_node):
	for i in 5:
		var spawn: Dictionary = {
			"coords": Vector3(-40 + i*20, 0, -30),
			"scale": Utils.get_random_vector3_in_range(1,4),
			"direction": Vector3(0, 0, randf_range(5.0, 15.0)),
			"rotation": Utils.get_random_vector3_in_range(0.1, 1.0),
			"hit_points": 20
		}
		var asteroid: Node    = asteroid_scene.instantiate()
		asteroid.init(root_node, spawn)
		root_node.add_child(asteroid)

func create_explosion(root_node, source_node, width, height):
	var explosion = explosion_scene.instantiate()
	var speed = 1.0
	explosion.init(source_node.global_transform.origin.x,
	source_node.global_transform.origin.z,
		width, height, speed)
	root_node.add_child(explosion)
	# TODO: Play sounds
	if source_node.is_in_group("modules"):
		for module in Utils.get_all_children(source_node):
			if module is MeshInstance3D:
				create_debris_from_module(root_node, module, source_node.scale)
	source_node.queue_free()

	
func create_hit_effect(root_node, enemy, bullet):
	var hit_effect = hit_effect_scene.instantiate()
	hit_effect.init(bullet.position.x, bullet.position.z)
	root_node.add_child(hit_effect)
	# TODO: Play sounds
	
	
func process_debris(delta):
	for mesh in get_tree().get_nodes_in_group("debris"):
		mesh.global_translate(mesh.get_meta("vector") * delta*10)
		var rotation = mesh.get_meta("rotation")
		mesh.rotate(Vector3(1,0,0), rotation.x * delta)
		mesh.rotate(Vector3(0,1,0), rotation.y * delta)
		mesh.rotate(Vector3(0,0,1), rotation.z * delta)
		var time_left =  mesh.get_meta("timer") - delta
		if time_left <= 0:
			mesh.queue_free()
		else:
			mesh.set_meta("timer", time_left)
			

func create_debris_from_module(root_node, module, scale):
	var debris = module.duplicate()
	debris.add_to_group("debris")
	debris.set_meta("vector", Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)))
	debris.set_meta("rotation", Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)))
	debris.set_meta("timer", 10.0)
	debris.scale_object_local(scale)
	debris.position = module.global_transform.origin
	debris.set_layer_mask_value(1, false)
	debris.set_layer_mask_value(10, true)
	root_node.add_child(debris)
