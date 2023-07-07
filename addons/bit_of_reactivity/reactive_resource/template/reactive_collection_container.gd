class_name ReactiveCollectionContainer
extends Control


## Base class for reactive containers. Used for displaying content
## of some [Array] typed property of the [ReactiveResource]


@export var _state_item_tscn: PackedScene

const COLLECTION_ITEM_META_NAME: StringName = "reactive_collection_item"

var _state_handler: ReactiveResource.PropertyHandler
var _state: Array


func setup(state_handler: ReactiveResource.PropertyHandler) -> void:
	if _state_handler:
		_state_handler.remove_callback(_on_state_updated)
	
	_state_handler = state_handler
	_state_handler.bind(_on_state_updated, _update_state)
	
	_on_state_updated()


func _exit_tree() -> void:
	if _state_handler:
		_state_handler.remove_callback(_on_state_updated)


func _on_state_updated() -> void:
	_state = _state_handler.get_value()
	var state_item_nodes = _get_state_item_nodes()
	
	var nodes_to_remove = state_item_nodes.filter(func(node):
		return not _state.has(node.state))
	
	for node in nodes_to_remove:
		_remove_state_item_node(node)
		state_item_nodes.erase(node)
	
	var nodes_state_items = state_item_nodes.map(func(node):
		return node.state)
	for state_item in _state:
		if not nodes_state_items.has(state_item):
			_create_state_item_node(state_item)
	
	_filter_items()
	_after_state_updated()


func _get_state_item_nodes() -> Array[Node]:
	var nodes: Array[Node]
	nodes.assign(get_children().filter(func(child):
		return (child.has_meta(COLLECTION_ITEM_META_NAME)
			and child.get_meta(COLLECTION_ITEM_META_NAME) == get_instance_id())))
	return nodes


func _append_state_item(state_item) -> void:
	_state.append(state_item)
	_create_state_item_node(state_item)
	_update_state()


func _create_state_item_node(state_item) -> void:
	var new_node = _state_item_tscn.instantiate()
	add_child(new_node)
	
	_setup_state_item_node(state_item, new_node)
	new_node.set_meta(COLLECTION_ITEM_META_NAME, get_instance_id())
	new_node.removing_requested.connect(_remove_state_item.bind(state_item))
	
	_after_state_item_node_created(state_item, new_node)


## Extension method
func _after_state_item_node_created(state_item, node: Node) -> void:
	pass


## Method to override setuping logic if necessary
func _setup_state_item_node(state_item, node: Node) -> void:
	node.setup(state_item)


func _remove_state_item(state_item) -> void:
	for node in _get_state_item_nodes():
		if node.state == state_item:
			_remove_state_item_node(node)
	
	_state.erase(state_item)
	_update_state()


func _remove_state_item_node(node: Node) -> void:
	_before_state_item_node_removed(node.state, node)
	remove_child(node)
	node.queue_free()


## Extension method
func _before_state_item_node_removed(state_item, node: Node) -> void:
	pass


## Reorder childrens. You can override it if necessary
func _filter_items() -> void:
	var state_nodes = _get_state_item_nodes()
	var nodes_states = state_nodes.map(func(node: Node):
		return node.state)
	
	for state_item in _state:
		var current_node_idx = nodes_states.find(state_item)
		move_child(state_nodes[current_node_idx], -1)


func _update_state() -> void:
	_state_handler.set_value(_state, _update_state)
	_after_state_updated()


## Extension method
func _after_state_updated() -> void:
	pass
