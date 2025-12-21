@tool
class_name ProtoConvert extends EditorScript

func _run():
	
	var sel := EditorInterface.get_selection()
	
	'''
    var cube = MeshInstance3D.new()
    get_scene().add_child(cube)
    cube.set_owner(get_scene())
	'''
	
	var nodes := sel.get_selected_nodes()
	
	for node in nodes:
		if node is CSGPrimitive3D:
			print(node)
			
			var shape :ArrayMesh= node.bake_static_mesh()
			
			var mesh = MeshInstance3D.new()
			mesh.name = 'Mesh' + node.name
			node.get_parent().add_child(mesh)
			mesh.set_owner(get_scene())
			mesh.mesh = shape
			mesh.transform = node.transform
			mesh.set_surface_override_material(0, load('res://pat/icerink_material.tres'))
			
			var col = StageComponent.new()
			col.name = 'StaticBody' + node.name
			node.get_parent().add_child(col)
			col.owner = get_scene()
			
			var cshape := CollisionShape3D.new()
			cshape.name = 'Col' + node.name
			cshape.shape = node.bake_collision_shape()
			col.transform = node.transform
			col.add_child(cshape)
			cshape.owner = get_scene()
			
			col.collision_layer = node.collision_layer
			col.collision_mask = node.collision_mask
			
			node.visible = false
			node.use_collision = false
