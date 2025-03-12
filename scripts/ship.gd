extends CharacterBody3D

@export var SPEED = 30
@export var FAST_SPEED = 60
@onready var weapons_node = $Weapons 
@onready var shield = $Shield/Sphere
@onready var shield_collision = $Shield/CollisionShape3D
@onready var body_mesh = $ship/Body

const MIN_SHIELD_ALPHA = 0.0
const MAX_SHIELD_ALPHA = 1
const MIN_EMISSION = 0.0
const MAX_EMISSION = 1

var shield_alpha = 0.0
var ship_emission = 0.0


var tilt = 0.0
var tilt_direction = 0.0
var MAX_TILT = 0.5
var shift_pressed = false
var max_hull_integrity = 100.0
var hull_integrity = max_hull_integrity
var max_shield_power = 100.0
var shield_power = max_shield_power

var weapons = []

signal player_destroyed()
signal update_hud()

func init():
	for weapon in weapons_node.get_children():
		if weapon.name == "RightMain":
			weapon.active = true
		if weapon.name == "LeftMain":
			weapon.active = true
		
		weapons.append(weapon)
	$ship/Weapons2.hide()
	shield.get_active_material(0).albedo_color.a = MIN_SHIELD_ALPHA

func _physics_process(delta: float) -> void:
	# Handle movement
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed = FAST_SPEED if shift_pressed else SPEED
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if velocity.x > 0:
		tilt_direction = -1.0
	elif velocity.x < 0:
		tilt_direction = 1.0
	else:
		if tilt > 0:
			tilt_direction = -1.0
		elif tilt < 0:
			tilt_direction = 1.0
		else:
			tilt_direction = 0
	var saved_tilt = tilt
	tilt += tilt_direction * delta
	if saved_tilt > 0 and tilt < 0 or saved_tilt < 0 and tilt > 0: 
		tilt = 0
		tilt_direction = 0 
	if tilt > -MAX_TILT and tilt< MAX_TILT: 
		rotation.z = tilt 
	else:
		tilt = clampf(tilt, -MAX_TILT, MAX_TILT)
	move_and_slide()
	
	# Handle shield
	if shield_alpha > MIN_SHIELD_ALPHA:
		shield_alpha -= delta / 1
		shield_alpha = clampf(shield_alpha, MIN_SHIELD_ALPHA, MAX_SHIELD_ALPHA)
		shield.get_active_material(0).albedo_color.a = shield_alpha 
	if ship_emission > MIN_EMISSION:
			ship_emission -= delta / 2.0
			ship_emission = clampf(ship_emission, MIN_EMISSION, MAX_EMISSION)
			set_emission()

func _input(event):
	shift_pressed = true if Input.is_action_pressed("accelerate") else false
	
	
func shield_hit(value):
	shield_alpha = MAX_SHIELD_ALPHA
	shield_power -= value
	
	
func remove_shield():
	shield_power = 0
	shield_collision.set_deferred("disabled", true)
	shield.visible = false
	
	
func process_hit(area, enemy_impact):
	var value = get_hit_points(area, enemy_impact)
	if shield_power > 0:
		shield_hit(value)
		update_hud.emit()
		if shield_power <= 0:
			value = -shield_power
			remove_shield()
	if shield_power <=0:
		hull_integrity -= value
		update_hud.emit()
		if hull_integrity <= 0:
			player_destroyed.emit()
	if enemy_impact:
		if hull_integrity > 0:
			area.explode()
		else:
			area.queue_free()
			
		
		
	
func get_hit_points(area, enemy_impact):
	return area.lifecycle.hit_points if enemy_impact else area.hit_points

func _on_area_3d_area_entered(area):
	var bullet_impact = area.is_in_group("alien_bullet")
	var enemy_impact = area.is_in_group("enemies")
	if bullet_impact or enemy_impact:
		ship_emission = MAX_EMISSION
		process_hit(area, enemy_impact)
		
func _on_shield_area_entered(area):
	var bullet_impact = area.is_in_group("alien_bullet")
	var enemy_impact = area.is_in_group("enemies")
	if bullet_impact or enemy_impact:
		process_hit(area, enemy_impact)
		
func reset_material():
	ship_emission = MIN_EMISSION
	set_emission()
	
func set_emission():
	body_mesh.get_active_material(0).emission = Color(ship_emission, ship_emission, ship_emission,1)
	
