extends Node

@onready var bullet_sound = $BulletSound 

func fire_bullet():
	bullet_sound.play()
	
# TODO: add explosion sound
func explode():
	pass
	
	
# TODO: Add metal and rock hit effects
func metal_hit_effect():
	pass

func rock_hit_effect():
	pass
