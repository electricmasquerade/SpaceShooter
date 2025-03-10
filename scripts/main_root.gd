extends Node3D

@onready var debug_overlay = $DebugOverlay
@onready var player = $Ship

func _ready():
	debug_overlay.init(player)
	GameManager.set_boundary($Boundary/LeftWall.position.x, 
		$Boundary/RightWall.position.x, 
		$Boundary/TopWall.position.z, 
		$Boundary/BottomWall.position.z)
	GameManager.spawn_stars(self)
	GameManager.spawn_asteroids(self)

	
func _process(delta: float) -> void:
	GameManager.process_background(self, delta)



func _on_ship_player_destroyed():
	player.queue_free()
