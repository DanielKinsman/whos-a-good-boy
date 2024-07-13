@tool
extends BTAction

@export var poi_nodes_path: NodePath

var ag: TestEnvironment
var dog: Doggo
var poi_parent: Node3D


func _enter() -> void:
    ag = agent
    dog = ag.get_node("Doggo")
    poi_parent = ag.get_node(poi_nodes_path)


func _tick(_delta: float) -> Status:
    var random_node_index := randi_range(0, poi_parent.get_child_count() - 1)
    dog.move_target = poi_parent.get_child(random_node_index)
    blackboard.set_var(&"current_poi", dog.move_target)
    return SUCCESS
