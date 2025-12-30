extends Node3D

@export var min_clamp_x: float = -1
@export var max_clamp_x: float = 1
@export var horizontal_acceleration: float = 2.0    # for joystick   
@export var vertical_acceleration: float = 1.0      # for joystick      
@export var mouse_acceleration: float = .002
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
    pass


func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        rotate_from_vector(-event.relative * mouse_acceleration)
        #rotation.y += event.relative.x * 0.002

func rotate_from_vector(v: Vector2):
    if v.length() == 0: return
    rotation.y += v.x
    rotation.x += v.y
    rotation.x = clamp(rotation.x, min_clamp_x, max_clamp_x)
