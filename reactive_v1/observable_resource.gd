class_name ObservableResource
extends Resource


var _bindings: Dictionary#[StringName, Array[Binding]]


func set_value(property: StringName, value, caller: Callable = func():) -> void:
	if not property in self:
		return
	
	self[property] = value
	
	if not _bindings.has(property):
		return
	
	for binding in _bindings[property]:
		if binding.caller != caller:
			binding.callback.call()


func bind(property: StringName, callback: Callable, caller: Callable = func():) -> void:
	if not _bindings.has(property):
		var bindings: Array[Binding]
		_bindings[property] = bindings
	
	_bindings[property].append(Binding.new(callback, caller))


func remove_callback(property: StringName, callback: Callable) -> void:
	if not _bindings.has(property):
		return
	
	_bindings[property] = _bindings[property].filter(func(binding: Binding):
		binding.callback != callback)


class Binding:
	var callback: Callable
	var caller: Callable
	
	func _init(callback: Callable, caller: Callable) -> void:
		self.callback = callback
		self.caller = caller
