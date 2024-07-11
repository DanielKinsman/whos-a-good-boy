@tool
extends BTAction

var ag: TestEnvironment
var dog: Doggo


func _enter() -> void:
    ag = agent
    dog = ag.get_node("Doggo")


func _tick(_delta: float) -> Status:
    if ag.held_objects.is_empty():
        return FAILURE

    dog.move_target = ag.held_objects.front()
    dog.orient_target = null
    return SUCCESS
