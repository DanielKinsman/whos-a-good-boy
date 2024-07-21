extends Node3D

@onready var rumbler: XRToolsRumbler = $XRToolsRumbler


func _ready() -> void:
    (get_parent() as XRToolsPickable).highlight_requested.connect(_on_highlight_requested)


func _on_highlight_requested(source: Node3D, _pickable: XRToolsPickable) -> void:
    if not (source is XRToolsFunctionPickup):
        return

    rumbler.rumble_hand(source)
