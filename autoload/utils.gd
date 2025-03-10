extends Node

func is_valid_node(node):
	return node and is_instance_valid(node)
	

func get_random_vector3_in_range(from, to):
	return Vector3(randf_range(from, to), randf_range(from,to), randf_range(from, to))

	
func get_all_children(in_node, array:=[]):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
	
	
func create_debris_from_module(root_node, module, scale):
	var debris = module.duplicate()
	debris.add_to_group("debris")
	debris.set_meta("vector", Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)))
	debris.set_meta("rotation", Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)))
	debris.set_meta("timer", 10.0)
	debris.scale_object_local(scale)
	debris.position = module.global_transform.origin
	root_node.add_child(debris)
