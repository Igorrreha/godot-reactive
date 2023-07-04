class_name DemoSubResourceView
extends VBoxContainer


@export var _data_spin_box: SpinBox

var _state: DemoObservableSubResource


func setup(data: DemoObservableSubResource) -> void:
	# long syntax (default)
	if _state:
		_state.remove_callback("another_important_data", _on_important_data_changed)
	
	_state = data
	_state.bind("another_important_data", _on_important_data_changed, _on_spin_box_value_changed)
	
	_on_important_data_changed()


func _on_important_data_changed() -> void:
	_data_spin_box.value = _state.another_important_data


func _on_spin_box_value_changed(value: float) -> void:
	_state.set_value("another_important_data", value, _on_spin_box_value_changed)
