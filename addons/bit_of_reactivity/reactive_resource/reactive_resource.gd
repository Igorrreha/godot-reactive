@icon("res://addons/bit_of_reactivity/reactive_resource/reactive_resource.svg")
class_name ReactiveResource
extends Resource


## Base class for reactive resources
## This class provides functional to bind setting of it's inner properties
## to custom callables call


## Collection of active [ReactiveResource.Binding]s for this resource properties
var _bindings: Dictionary#[StringName, Array[ReactiveResource.Binding]]


## "Syntactic sugar" for complex setuping of an object.
## This method
## 1. removes old bindings if necessary
## 2. creates new bindings
## 3. sets resource_property value to self
## 4. calls the callbacks of the created bindings
func setup_bindings(resource_holder: Object, resource_property: String,
		bindings: Array[Binding]) -> void:
	if not resource_property in resource_holder:
		printerr("Binding failed! %s is not in %s" % [resource_property, resource_holder])
		return
	
	var old_resource: ReactiveResource = resource_holder[resource_property]
	for binding in bindings:
		if old_resource:
			old_resource.remove_callback(binding.property, binding.callback)
		
		self.bind(binding.property, binding.callback, binding.caller)
	
	resource_holder[resource_property] = self
	
	for binding in bindings:
		binding.callback.call()


## Setter for reactive property of resource.
## After applying the value invokes all binded callables.
## The caller argument is used to ignore some bindings invoking
func set_value(property: StringName, value, caller: Callable = func():) -> void:
	if not property in self:
		return
	
	self[property] = value
	
	if not _bindings.has(property):
		return
	
	for binding in _bindings[property]:
		binding.apply(caller)


## Creates new [ReactiveResource.Binding]
func bind(property: StringName, callback: Callable, caller: Callable = func():) -> void:
	if not _bindings.has(property):
		var bindings: Array[Binding]
		_bindings[property] = bindings
	
	_bindings[property].append(Binding.new(property, callback, caller))


## Removes all [ReactiveResource.Binding]s of property that contains provided callback
func remove_callback(property: StringName, callback: Callable) -> void:
	if not _bindings.has(property):
		return
	
	_bindings[property] = _bindings[property].filter(func(binding: Binding):
		binding.callback != callback)


class Binding:
	var property: String
	## The method that invokes at binding applying
	var callback: Callable
	## The caller is used for evading of resetting property by callback in the place where it
	## already setted manually
	var caller: Callable
	
	
	func _init(property: String, callback: Callable, caller: Callable = func():) -> void:
		self.callback = callback
		self.property = property
		self.caller = caller
	
	
	func apply(caller: Callable = func():) -> void:
		if self.caller != caller:
			callback.call()
