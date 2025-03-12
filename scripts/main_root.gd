extends Node3D

@onready var debug_overlay = $DebugOverlay
@onready var player = $Ship
@onready var hud = $HUD
@onready var camera = $Camera3D

var fire_cadence = 0.2
var fire_cooldown = 0.0
var current_level
var level_loaded = false

func _ready():
	debug_overlay.init(player)
	GameManager.set_boundary($Boundary/LeftWall.position.x, 
		$Boundary/RightWall.position.x, 
		$Boundary/TopWall.position.z, 
		$Boundary/BottomWall.position.z)
	GameManager.spawn_stars(self)
	player.init()
	GameManager.set_player(player)
	player.update_hud.connect(_on_update_hud)
	GameManager.set_camera(camera)

	
func _process(delta: float) -> void:
	if level_loaded:
		GameManager.process_background(self, delta)
		GameManager.process_debris(delta)
		current_level.process(self, delta)
		if Input.is_action_pressed("shoot") and fire_cooldown <= 0:
			fire_bullet()
		fire_cooldown -= delta
		
	else:
		current_level = LevelManager.load_level("tutorial")
		current_level.init(self)
		level_loaded = true
		


func fire_bullet():
	if Utils.is_valid_node(player):
		fire_cooldown = fire_cadence
		GameManager.fire_player_weapon(self)
		
func _on_weapon_fired(enemy, event):		
	GameManager.fire_enemy_weapon(self, enemy, event)
	
func _on_update_hud():
	hud.set_player_values(player)

func _on_ship_player_destroyed():
	GameManager.create_explosion(self, player, 30, 30)
	player.queue_free()
	
func _on_enemy_destroyed(enemy):
	GameManager.create_explosion(self, enemy, 15,15)
	enemy.queue_free()
	
	
func _on_show_hit_effect(enemy, bullet):
	GameManager.create_hit_effect(self, enemy, bullet)
	
