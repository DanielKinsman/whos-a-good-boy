@tool
extends BTAction

var ag: TestEnvironment
var dog: Doggo


func _enter() -> void:
    ag = agent
    dog = ag.get_node("Doggo")


func _tick(_delta: float) -> Status:
    ag.thrown_object = null
    dog.move_target = null
    dog.orient_target = null
    return SUCCESS
