class_name ObservableResource
extends Resource


signal property_changed(name: String)


func _before_property_changed(name: String) -> void:
	if not name in self:
		return
	
	var value = self[name]
	if value is ObservableResource:
		value.property_changed.disconnect(_after_child_property_changed)


func _after_property_changed(name: String) -> void:
	property_changed.emit(name)
	
	if not name in self:
		return
	
	var value = self[name]
	if value is ObservableResource:
		value.property_changed.connect(_after_child_property_changed.bind(name))


func _after_child_property_changed(property: String, child_name: String) -> void:
	property_changed.emit(child_name.path_join(property))
