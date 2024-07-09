@tool
extends BTAction

const THRESHOLD := 0.1**2


var dog: Doggo


func _enter() -> void:
    dog = agent.get_node("Doggo")


func _tick(_delta: float) -> Status:
    if dog.velocity.length_squared() > THRESHOLD:
        return RUNNING

    return SUCCESS
