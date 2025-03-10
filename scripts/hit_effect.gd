extends CPUParticles3D

var elapsed_time = 0.0

func init(x, z):
	translate(Vector3(x, 10, z))
	emitting = true
	restart()
	
	
func _physics_process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time > 0.5:
		emitting = false
		# TODO: play sounds
		queue_free()
