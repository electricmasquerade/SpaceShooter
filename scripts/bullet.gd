extends Area3D

var current_direction
@export var hit_points = 5.0
@export var speed = 150.0
@onready var bullet_trail = $Trail

func init(weapon):
	position = weapon.global_position
	position.y = 0
	
	var direction_node = weapon.get_children()[0]
	current_direction = direction_node.position
	
	var direction_angle: float = Vector2(current_direction.x, current_direction.z).angle_to(Vector2.UP)
	rotate_y(direction_angle)
	
func _process(delta):
	translate(Vector3(0,0, -delta*speed))
	bullet_trail.add_new_point(GameManager.to_2D(global_position))
	if !GameManager.is_in_boundary(self):
		queue_free()
