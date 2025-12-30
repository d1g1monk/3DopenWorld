extends CanvasLayer


func _process(_delta: float) -> void:
    $VBoxContainer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
    $VBoxContainer/Speed.text = "Speed: " + str(round(GameManager.Player.speedometer()))
    
