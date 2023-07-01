class_name DemoResourceView
extends VBoxContainer


@export var _title: String
@export var _title_label: Label

@export var _data_line_edit: LineEdit
@export var _sub_resource_view: DemoSubResourceView

var _state: DemoObservableResource


func setup(data: DemoObservableResource) -> void:
	if _state:
		_state.remove_callback("some_important_data", _on_important_data_changed)
		_state.remove_callback("sub_resource", _on_sub_resource_changed)
	
	_state = data
	_state.bind("some_important_data", _on_important_data_changed, _on_line_edit_text_changed)
	_state.bind("sub_resource", _on_sub_resource_changed)
	
	_on_important_data_changed()
	_on_sub_resource_changed()


func _ready() -> void:
	_title_label.text = _title


func _on_important_data_changed() -> void:
	_data_line_edit.text = _state.some_important_data


func _on_sub_resource_changed() -> void:
	_sub_resource_view.setup(_state.sub_resource)


func _on_line_edit_text_changed(new_text: String) -> void:
	_state.set_value("some_important_data", new_text, _on_line_edit_text_changed)
