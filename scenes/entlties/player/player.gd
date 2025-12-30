extends CharacterBody3D

@export var base_speed: float = 4.0
@export var gravity: float 
@export var run_speed: float = base_speed * 2
@export var block_speed: float = base_speed / 2
@export var is_running: bool = false
#jump
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var camera =  $CameraManager/Camera3D

var movement_input: Vector2 = Vector2.ZERO
var defend: bool = false:
    set(value):
        if !defend and value:
            $GodetteSkin.defend(true)
        if defend and !value:
            $GodetteSkin.defend(false)
        defend = value
          

func _ready() -> void:
    GameManager.Player = self

func _physics_process(delta: float) -> void:
    movement_logic(delta)
    jump_logic() 
    gravity_logic(delta)
    move_and_slide()
    ability_logic()

func speedometer() -> float:
    return Vector2((velocity.x), (velocity.z)).length()
    
 
func movement_logic(delta):
    var speed = run_speed if is_running else base_speed
    speed = block_speed if defend else speed
    var raw_input = Input.get_vector("left", "right", "forward", "backwards")
    #velocity = Vector3(movement_input.x, 0, movement_input.y) * base_speed
    movement_input = raw_input.rotated(-camera.global_rotation.y)
    var vel_2d = Vector2(velocity.x, velocity.z)
    #Snappy turns
    if vel_2d.dot(movement_input) < 0:
        vel_2d = Vector2.ZERO
        
    if raw_input != Vector2.ZERO:
        if Input.is_action_just_pressed("run"):
            is_running = !is_running
            print(is_running)      
        if is_running:
            vel_2d += movement_input * speed * delta
            vel_2d = vel_2d.limit_length(speed)
            $GodetteSkin.set_move_state("Running_C") 
        if !is_running:
            vel_2d += movement_input * speed * delta
            vel_2d = vel_2d.limit_length(speed)
        # Or: if vel_2d.length() > base_speed:
                 #vel_2d = vel_2d.normalized() * base_speed
            $GodetteSkin.set_move_state("Running_A")
        velocity.x = vel_2d.x
        velocity.z = vel_2d.y
    else:
        vel_2d = vel_2d.move_toward(Vector2.ZERO, speed * 5555 * delta)
        velocity.x = vel_2d.x
        velocity.z = vel_2d.y
        $GodetteSkin.set_move_state("Idle")
    # Turn the rig based on input
    if raw_input.length() > 0:
        $GodetteSkin.rotation.y = rotate_toward($GodetteSkin.rotation.y, - movement_input.angle(), 22.0 * delta)    
       
     
func jump_logic():
    if is_on_floor():
        if Input.is_action_just_pressed("jump"):
            velocity.y = -jump_velocity  
    else:
        $GodetteSkin.set_move_state("Jump_Idle") 


func gravity_logic(delta):
    gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
    velocity.y -= gravity * delta


func ability_logic() -> void:
    if Input.is_action_just_pressed("ability"):
        $GodetteSkin.attack()    
    defend = Input.is_action_pressed("block")
     
