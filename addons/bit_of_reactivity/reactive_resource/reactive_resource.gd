@icon("res://addons/bit_of_reactivity/reactive_resource/reactive_resource.svg")
class_name ReactiveResource
extends Resource


## Base class for reactive resources
## This class provides functional to bind setting of it's inner properties
## to custom callables call


## Collection of active [ReactiveResource.Binding]s of this resource properties
var _bindings: Dictionary#[StringName, Array[ReactiveResource.Binding]]

## Collection of [ReactiveResource.PropertyHandler]s of this resource properties
var _handlers: Dictionary#[StringName, PropertyHandler]


## "Syntactic sugar" for complex setuping of an object.
## This method
## 1. removes old bindings if necessary
## 2. creates new bindings
## 3. sets resource_property value to self
## 4. calls the callbacks of the created bindings
func setup_bindings(resource_holder: Object, resource_property: StringName,
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


func _get_value(property: StringName) -> Variant:
	return self[property]


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


## Returns [ReactiveResource.PropertyHandler] of given property
func get_handler(property: StringName) -> PropertyHandler:
	if not _handlers.has(property):
		_handlers[property] = PropertyHandler.new(property, _get_value, set_value,
			bind, remove_callback)
	
	return _handlers[property] as PropertyHandler


## Wrapper of some property of [ReactiveResource].
## Can be used to provide parts of the [ReactiveResource] to classes where using the
## entire resource is redundant.
## Most common usecase is making collections reactive
## (please, check the plugin demo if you need more info)
class PropertyHandler:
	var _get_value_method: Callable
	var _set_value_method: Callable
	var _bind_method: Callable
	var _remove_callback_method: Callable
	var property: StringName
	
	
	func get_value() -> Variant:
		return _get_value_method.call(property)
	
	
	func set_value(value, caller: Callable = func():) -> void:
		_set_value_method.call(property, value, caller)
	
	
	func bind(callback: Callable, caller: Callable = func():) -> void:
		_bind_method.call(property, callback, caller)
	
	
	func remove_callback(callback: Callable) -> void:
		if _remove_callback_method.is_valid():
			_remove_callback_method.call(property, callback)
	
	
	func _init(property: StringName, get_value_method: Callable, set_value_method: Callable,
			bind_method: Callable, remove_callback_method: Callable) -> void:
		_get_value_method = get_value_method
		_set_value_method = set_value_method
		_bind_method = bind_method
		_remove_callback_method = remove_callback_method
		self.property = property


class Binding:
	var property: StringName
	## The method that invokes at binding applying
	var callback: Callable
	## The caller is used for evading of resetting property by callback in the place where it
	## already setted manually
	var caller: Callable
	
	
	func _init(property: StringName, callback: Callable, caller: Callable = func():) -> void:
		self.callback = callback
		self.property = property
		self.caller = caller
	
	
	func apply(caller: Callable = func():) -> void:
		if self.caller != caller:
			callback.call()
