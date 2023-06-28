extends Node


@export var graph_node: MyGraphNode
var node_v1: SolutionNode


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var input_key = event as InputEventKey
		match input_key.keycode:
			KEY_1:
				node_v1 = SolutionNode.new()
				node_v1.bind("position", func():
					print(node_v1.position))
				
				var content = SolutionClass.new()
				node_v1.content = content
				content.variable = SolutionVariable.new()
				content.variable.name = "test_var"
				content.variable.type = "String"
				
				graph_node.setup(node_v1)
				print("1")
			
			KEY_2:
				if not node_v1:
					return
				
				print("prev name: %s" % node_v1.content.self_class_name)
				node_v1.content.set_value("self_class_name", str(randi())) 
				print("new name: %s" % node_v1.content.self_class_name)
				node_v1.content.set_value("parent_class_name", "P" + str(randi()))
				node_v1.set_value("position", node_v1.position + Vector2(10, 10))
			
			KEY_3:
				pass
