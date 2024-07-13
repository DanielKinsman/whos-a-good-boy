@tool
extends BTAction

var dog: Doggo


func _enter() -> void:
    dog = agent.get_node("Doggo")


func _tick(_delta: float) -> Status:
    if not is_instance_valid(dog.mouth_snap_zone.picked_up_object):
        return FAILURE

    dog.dropped_voluntarily = true
    dog.mouth_snap_zone.drop_object()
    return SUCCESS
