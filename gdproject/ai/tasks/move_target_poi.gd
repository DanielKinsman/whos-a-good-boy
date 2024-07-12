@tool
extends BTAction

@export var poi_node_path: NodePath

var ag: TestEnvironment
var dog: Doggo


func _enter() -> void:
    ag = agent
    dog = ag.get_node("Doggo")


func _tick(_delta: float) -> Status:
    dog.move_target = ag.get_node(poi_node_path)
    return SUCCESS
