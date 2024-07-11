@tool
extends BTAction

var ag: TestEnvironment
var dog: Doggo


func _enter() -> void:
    ag = agent
    dog = ag.get_node("Doggo")

    print("entered clear")
    print(ag.thrown_object)
    print("held:")
    print(ag.held_objects)


func _tick(_delta: float) -> Status:
    ag.thrown_object = null
    ag.held_objects.clear()
    dog.move_target = null
    dog.orient_target = null
    return SUCCESS
