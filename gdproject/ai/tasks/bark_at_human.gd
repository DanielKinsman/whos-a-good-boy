@tool
extends BTAction

var ag: TestEnvironment
var dog: Doggo


func _enter() -> void:
    ag = agent
    dog = ag.get_node("Doggo")


func _tick(_delta: float) -> Status:
    dog.orient_target = ag.get_camera()
    dog.animation.set("parameters/Transition/transition_request", "bark")
    return SUCCESS
