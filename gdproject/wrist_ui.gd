extends CenterContainer


func _ready() -> void:
    $HBoxContainer/QuitButton.connect("button_up", self.quit)


func quit() -> void:
    get_tree().quit()
