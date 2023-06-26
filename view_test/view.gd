extends GraphNode


@export var _class_name: LineEdit
@export var _parent_class_name: LineEdit

var _state: SolutionNode


func setup(state: SolutionNode) -> void:
	if _state:
		_state.property_changed.disconnect(_on_state_property_changed)
	
	_state = state
	_state.property_changed.connect(_on_state_property_changed)


func _on_state_property_changed(property_name: String) -> void:
	match property_name:
		"position":
			position_offset = _state.position
		
		"content/self_class_name":
			_class_name.text = _state.content.self_class_name
		
		"content/parent_class_name":
			_parent_class_name.text = _state.content.parent_class_name


func _on_name_text_changed(new_text: String) -> void:
	_state.content.self_class_name = new_text


func _on_parent_name_text_changed(new_text: String) -> void:
	_state.content.parent_class_name = new_text


func _on_position_offset_changed() -> void:
	_state.position = position_offset
