class_name SolutionClass
extends SolutionNodeContent


var self_class_name: String:
	set(v):
		_before_property_changed("self_class_name")
		self_class_name = v
		_after_property_changed("self_class_name")
var parent_class_name: String:
	set(v):
		_before_property_changed("parent_class_name")
		parent_class_name = v
		_after_property_changed("parent_class_name")
var variable: SolutionVariable:
	set(v):
		_before_property_changed("variable")
		variable = v
		_after_property_changed("variable")
