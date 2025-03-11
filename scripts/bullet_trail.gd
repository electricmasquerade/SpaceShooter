extends Line2D

@export var min_spawn_distance = 5.0
@export var wilderness = 3.0
@export var gradient_color : Gradient = Gradient.new()
@export var lifetime_min = 0.5
@export var lifetime_max = 1.0

var tick_speed = 0.05
var tick = 0.0
var wild_speed = 0.1
var point_age = [0.0]

func _ready():
	gradient = gradient_color
	clear_points()
	stop()
	
func stop():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, randf_range(lifetime_min, 
					lifetime_max)).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

func _process(delta):
	if tick > tick_speed:
		tick = 0
		for p in range(get_point_count()):
			point_age[p] += delta
			var rand_vector = Vector2(randf_range(-wild_speed, wild_speed), 
							randf_range(-wild_speed, wild_speed))
			points[p] += rand_vector * wilderness * point_age[p] 
	else:
		tick += delta
		
func add_new_point(point_pos, at_pos = -1):		
	if get_point_count() > 0 and point_pos.distance_to(points[get_point_count() - 1]) < min_spawn_distance:
		return
	point_age.append(0.0)
	add_point(point_pos, at_pos)
	
