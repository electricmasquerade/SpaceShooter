extends Label

const c = RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME
const v = RenderingServer.RENDERING_INFO_VIDEO_MEM_USED

@export var show_debug_overlay = true

var FPS = 0
var draw_calls = 0
var frame_time = 0
var video_mem = 0
var player
var small_stars = 0
var asteroids = 0

func init(_player):
	player = _player
	
	
func _process(delta):
	if not show_debug_overlay:
		text = ""
		return
	FPS = Engine.get_frames_per_second()
	draw_calls = RenderingServer.get_rendering_info(c)
	frame_time = delta
	video_mem = RenderingServer.get_rendering_info(v) / 1024.0 / 1024.0
	small_stars = get_tree().get_nodes_in_group("small_star").size()
	asteroids = get_tree().get_nodes_in_group("enemies").size()
	
	var data = "FPS: %d \nDraw Calls: %d \nFrame Time: %f \nVideo Mem: %f MB \nSmall Stars: %d \nEnemies: %d" % [
	FPS, 
	draw_calls, 
	frame_time, 
	video_mem,
	small_stars,
	asteroids]
	
	if Utils.is_valid_node(player):
		data += "\nPlayer Pos: %v \nPlayer Rot: %v" % [player.global_position, player.global_rotation_degrees]
		
	text = data
		
	
