extends Button


func _ready() -> void:
    self.pressed.connect(func() -> void: get_tree().quit())
