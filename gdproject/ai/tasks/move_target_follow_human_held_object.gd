@tool
extends BTAction

var ag: TestEnvironment
var dog: Doggo


func _enter() -> void:
    ag = agent
    dog = ag.get_node("Doggo")


func _tick(_delta: float) -> Status:
    if not is_instance_valid(ag.held_object):
        return FAILURE

    dog.move_target = ag.held_object
    return SUCCESS
