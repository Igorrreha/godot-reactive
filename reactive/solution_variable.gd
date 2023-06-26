class_name SolutionVariable
extends ObservableResource


var name: String:
	set(v):
		_before_property_changed("name")
		name = v
		_after_property_changed("name")
var type: String:
	set(v):
		_before_property_changed("type")
		type = v
		_after_property_changed("type")
