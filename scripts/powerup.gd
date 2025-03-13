class_name PowerUp
extends Area3D

@export var shield_boost = 0.0
@export var activate_side_weapons = false

var lifecycle = PowerUpLifecycle.new()

func init(enemy):
	position = enemy.global_position
	lifecycle.init(self)
	enemy.power_up = null
	
func _process(delta):	
	lifecycle.process(self, delta)
