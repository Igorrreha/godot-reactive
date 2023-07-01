extends HBoxContainer


@export var _resource_view: DemoResourceView

# we use DemoResourceView as resource_model in this demo
# for simplifying demonstration of reactive connection of two objects
# in the real solution you will have separate Model class with it's own logic inside
@export var _resource_model: DemoResourceView
 

func _ready() -> void:
	var resource = DemoObservableResource.new()
	resource.sub_resource = DemoObservableSubResource.new()
	_resource_model.setup(resource)
	_resource_view.setup(resource)
