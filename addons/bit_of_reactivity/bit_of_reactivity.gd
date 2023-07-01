@tool
extends EditorPlugin


func _enter_tree() -> void:
	# now plugin provides only ReactiveResource class that available
	# in any plugin state: activated or deactivated
	# enjoy! ;)
	pass


func _exit_tree() -> void:
	pass
