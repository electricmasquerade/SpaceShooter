class_name Enemy
extends Area3D

var lifecycle = Lifecycle.new();
var weapons = []
var power_up

func init(root_node, spawn, timeline):
	for node in get_children():
		if node.name == "Weapons":
			weapons = node.get_children()
	lifecycle.init(root_node, self, spawn, timeline)
	
func _process(delta):
	lifecycle.process(self, delta)
	


func _on_area_entered(area):
	if area.is_in_group("bullet"):
		lifecycle.process_hit(self, area)
		area.queue_free()

func explode():
	lifecycle.explode(self)
