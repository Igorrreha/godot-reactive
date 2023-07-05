class_name DemoReactiveCollectionContainer
extends VBoxContainer


@export var _collection_item_tscn: PackedScene
@export var _items_container: Node

var _state_handler: ReactiveResource.PropertyHandler
var _state: Array[String]


func setup(collection_handler: ReactiveResource.PropertyHandler) -> void:
	if _state_handler:
		_state_handler.remove_callback(_on_state_updated)
	
	_state_handler = collection_handler
	_state_handler.bind(_on_state_updated, _update_state)
	
	_on_state_updated()


func add_item() -> void:
	var new_item = str(randi())
	_state.append(new_item)
	_create_item_node(new_item)
	_update_state()


func remove_last_item() -> void:
	if _state.is_empty():
		return
	
	var last_child_idx = _state.size() - 1
	_state.remove_at(last_child_idx)
	_items_container.remove_child(_items_container.get_child(last_child_idx))
	_update_state()


func _update_state() -> void:
	_state_handler.set_value(_state, _update_state)


func _on_state_updated() -> void:
	_state = _state_handler.get_value()
	
	for child in _items_container.get_children():
		child.queue_free()
	
	for item in _state:
		_create_item_node(item)


func _create_item_node(item) -> void:
	var item_node = _collection_item_tscn.instantiate() as Label
	item_node.text = item
	_items_container.add_child(item_node)
