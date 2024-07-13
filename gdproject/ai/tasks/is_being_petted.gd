@tool
extends BTAction

var dog: Doggo


func _enter() -> void:
    dog = agent.get_node("Doggo")


func _tick(_delta: float) -> Status:
    if dog.is_being_pet:
        return SUCCESS

    return FAILURE
