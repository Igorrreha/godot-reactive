class_name ReactiveResource
extends Resource


## Base class for reactive resources
## This class provides functional to bind setting of it's inner properties
## to custom callables call


## Collection of active [ReactiveResource.Binding]s for this resource properties
var _bindings: Dictionary#[StringName, Array[ReactiveResource.Binding]]


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
	
	_bindings[property].append(Binding.new(callback, caller))


## Removes all [ReactiveResource.Binding]s of property that contains provided callback
func remove_callback(property: StringName, callback: Callable) -> void:
	if not _bindings.has(property):
		return
	
	_bindings[property] = _bindings[property].filter(func(binding: Binding):
		binding.callback != callback)


class Binding:
	## The method that invokes at binding applying
	var callback: Callable
	## The caller is used for evading of resetting property by callback in the place where it
	## already setted manually
	var _caller: Callable
	
	
	func _init(callback: Callable, caller: Callable) -> void:
		self.callback = callback
		_caller = caller
	
	
	func apply(caller: Callable) -> void:
		if caller != _caller:
			callback.call()
