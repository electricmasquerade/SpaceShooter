extends Node

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var alien_ship_scene = preload("res://scenes/alien_ship.tscn")

var timeline = []
var elapsed_time = 0.0
var previous_second = 0

func init(node, more_scenes = []):
	timeline.append({"timestamp": 1, "wave": get_asteroid_wave() })
	timeline.append({"timestamp": 2, "wave": get_alien_ship_wave() })
	
func process(node, delta):
	elapsed_time += delta
	if elapsed_time - previous_second > 1.0:
		previous_second += 1
		for event in timeline:
			if event.timestamp <= elapsed_time and !event.has("processed"):
				process_wave(node, event.wave)
				event.processed = true

func process_wave(node, wave):
	for item in wave:
		var enemy = item.enemy.instantiate()
		enemy.init(node, item.spawn, item.timeline)
		node.add_child(enemy)
		
func get_asteroid_wave():		
	var wave = []
	for i in 11:
		wave.append({
			"enemy":asteroid_scene,
			"spawn": {
				"hit_points": 20.0,
				"coords": Vector3(Utils.get_random_x_in_viewport(10), 0, GameManager.boundary.top - i *2),
				"scale": Utils.get_random_vector3_in_range(1,4),
				"direction": Vector3(0,0, randf_range(5.0, 15.0)),
				"rotation": Utils.get_random_vector3_in_range(0.1,1.0),
				},
			"timeline": []
		})
		return wave
		
func get_alien_ship_wave():
	var wave = []
	for i in 11:
		wave.append({
			"enemy": alien_ship_scene,
			"spawn": {
				"hit_points": 20.0,
				"coords": Vector3(-50 + i * 10, 0, GameManager.boundary.top + i),
				"scale": Vector3(5,5,5),
				"direction": Vector3(0,0, 2),
				"rotation": Vector3(0,0,0),
				
			},
			"timeline": get_alien_ship_timeline()
		})
	return wave
		
func get_alien_ship_timeline():		
	return [{
		"timestamp": 5, 
		"fire": {
			"shot": alien_ship_scene,
			"weapon": "Main",
		}
	}
	]
