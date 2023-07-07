extends Label


# The item that represents reactive collection item.
# All members of this class required by ReactiveCollectionContainer.


signal removing_requested


var state:
	get:
		return text


func setup(state: String) -> void:
	text = state
