extends Node


var node: SolutionNode


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var input_key = event as InputEventKey
		match input_key.keycode:
			KEY_1:
				node = SolutionNode.new()
				node.property_changed.connect(func(v):
					print(v))
				
				var content = SolutionClass.new()
				node.content = content
				content.variable = SolutionVariable.new()
				content.variable.name = "test_var"
				content.variable.type = "String"
				
				$GraphEdit/GraphNode.setup(node)
				print("1")
			
			KEY_2:
				if not node:
					return
				
				print("prev name: %s" % node.content.self_class_name)
				node.content.self_class_name = str(randi())
				print("new name: %s" % node.content.self_class_name)
				node.content.parent_class_name = "P" + str(randi())
				node.position += Vector2(10, 10)
