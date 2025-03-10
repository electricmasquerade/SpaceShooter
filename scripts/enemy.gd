class_name Enemy
extends Area3D

var lifecycle = Lifecycle.new();

func init(root_node, spawn):
	lifecycle.init(root_node, self, spawn)
	
func _process(delta):
	lifecycle.process(self, delta)
	


func _on_area_entered(area):
	print(area)
