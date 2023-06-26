class_name SolutionNode
extends ObservableResource


var position: Vector2:
	set(v):
		_before_property_changed("position")
		position = v
		_after_property_changed("position")
var content: SolutionNodeContent:
	set(v):
		_before_property_changed("content")
		content = v
		_after_property_changed("content")
