class_name DemoReactiveCollectionContainer
extends ReactiveCollectionContainer


# This script demonstrates the simplest way of creating a reactive collection container.
# The main part of logic is in ReactiveCollectionContainer template class, if you want to get more
# detalized view - please dive inside it


func add_item() -> void:
	var new_item = str(randi())
	_append_state_item(new_item)


func remove_last_item() -> void:
	if _state.is_empty():
		return
	
	_remove_state_item(_state[-1])
