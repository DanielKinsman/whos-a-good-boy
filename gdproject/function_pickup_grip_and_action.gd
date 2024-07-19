@tool
@icon("res://addons/godot-xr-tools/editor/icons/function.svg")
class_name FunctionPickupGripAndAction
extends XRToolsFunctionPickup


func _process(delta: float) -> void:
    # Do not process if in the editor
    if Engine.is_editor_hint():
        return

    # Skip if disabled, or the controller isn't active
    if !enabled or !_controller.get_is_active():
        return

    # Handle our grip
    var grip_value := _controller.get_float(pickup_axis_action)
    grip_value += _grip_threshold * 2.0 if _controller.is_button_pressed(action_button_action) else 0.0
    if (grip_pressed and grip_value < (_grip_threshold - 0.1)):
        grip_pressed = false
        _on_grip_release()
    elif (!grip_pressed and grip_value > (_grip_threshold + 0.1)):
        grip_pressed = true
        _on_grip_pressed()

    # Calculate average velocity
    if is_instance_valid(picked_up_object) and (picked_up_object as XRToolsPickable).is_picked_up():
        # Average velocity of picked up object
        _velocity_averager.add_transform(delta, picked_up_object.global_transform)
    else:
        # Average velocity of this pickup
        _velocity_averager.add_transform(delta, global_transform)

    _update_closest_object()
