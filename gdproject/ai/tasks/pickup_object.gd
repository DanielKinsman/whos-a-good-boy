@tool
extends BTAction

var dog: Doggo


func _enter() -> void:
    dog = agent.get_node("Doggo")


func _tick(_delta: float) -> Status:
    if not (dog.move_target is XRToolsPickable):
        return FAILURE

    dog.mouth_snap_zone.pick_up_object(dog.move_target)
    return SUCCESS
