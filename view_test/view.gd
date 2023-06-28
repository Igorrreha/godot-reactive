class_name MyGraphNode
extends GraphNode


@export var _class_name: LineEdit
@export var _parent_class_name: LineEdit

var _state: SolutionNode


func setup(state: SolutionNode) -> void:
	if _state:
		_state.remove_callback("position", _on_state_property_changed)
		_state.content.remove_callback("self_class_name", _on_class_name_changed)
		_state.content.remove_callback("parent_class_name", _on_parent_class_name_changed)
	
	_state = state
	_state.bind("position", _on_state_property_changed)
	_state.content.bind("self_class_name", _on_class_name_changed, _on_name_text_changed)
	_state.content.bind("parent_class_name", _on_parent_class_name_changed, _on_parent_name_text_changed)


func _on_state_property_changed() -> void:
	position_offset = _state.position


func _on_class_name_changed() -> void:
	_class_name.text = _state.content.self_class_name


func _on_parent_class_name_changed() -> void:
	_parent_class_name.text = _state.content.parent_class_name


func _on_name_text_changed(new_text: String) -> void:
	_state.content.set_value("self_class_name", new_text, _on_name_text_changed)


func _on_parent_name_text_changed(new_text: String) -> void:
	_state.content.set_value("parent_class_name", new_text, _on_parent_name_text_changed)


func _on_position_offset_changed() -> void:
	_state.set_value("position", position_offset)
