extends CharacterBody3D

@export var SPEED = 30
@export var FAST_SPEED = 60
@onready var weapons_node = $Weapons 
var tilt = 0.0
var tilt_direction = 0.0
var MAX_TILT = 0.5
var shift_pressed = false

var weapons = []

signal player_destroyed()

func init():
	for weapon in weapons_node.get_children():
		if weapon.name == "RightMain":
			weapon.active = true
		if weapon.name == "LeftMain":
			weapon.active = true
		weapons.append(weapon)
	$ship/Weapons2.hide()

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

func _input(event):
	shift_pressed = true if Input.is_action_pressed("accelerate") else false
	
	

func _on_area_3d_area_entered(area):
	player_destroyed.emit()
