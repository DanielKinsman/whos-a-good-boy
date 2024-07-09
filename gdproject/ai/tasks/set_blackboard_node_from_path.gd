@tool
extends BTAction

@export var node_path: NodePath
@export var output_var: StringName


func _tick(_delta: float) -> Status:
    var node := agent.get_node(node_path)
    if not is_instance_valid(node):
        return FAILURE

    blackboard.set_var(output_var, node)
    return SUCCESS
