extends Node

@onready var small_star_scene = preload("res://scenes/small_star.tscn")
@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")

var boundary = {
	"left": 0, 
	"right": 0, 
	"top": 0, 
	"bottom": 0
}

var boundary_margin = 10

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
		var spawn = {
			"coords": Vector3(-40 + i*20, 0, -30),
			"scale": Utils.get_random_vector3_in_range(1,4),
			"direction": Vector3(0, 0, randf_range(5.0, 15.0)),
			"rotation": Utils.get_random_vector3_in_range(0.1, 1.0)
		}
		var asteroid = asteroid_scene.instantiate()
		asteroid.init(root_node, spawn)
		root_node.add_child(asteroid)
